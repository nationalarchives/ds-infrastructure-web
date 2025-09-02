# 1. Instances Overview
| Instance Name           | Purpose                                      | Notes                                                                                        |
| ----------------------- | -------------------------------------------- | -------------------------------------------------------------------------------------------- |
| `web-frontend`          | Frontend application                         | Runs container for frontend. Uses **website-reverse-proxy** as its reverse proxy. |
| `wagtail`               | Wagtail CMS                                  | Mounted **EFS** at `/media`. Handles content management.                                     |
| `catalogue`             | Catalogue service                            | Handles catalogue API. Reverse proxied via **beta-rp** instance.                             |
| `search`                | Search service                               | Handles search functionality. Reverse proxied via **beta-rp** instance. (Later changes to website-reverse-proxy)                     |
| `website-reverse-proxy` | Reverse proxy for `web-frontend` & `wagtail` | Nginx manages routing to frontend and Wagtail containers.                                  |
| `beta-rp`               | Reverse proxy for `search` & `catalogue`     | Nginx manages routing for these services.                                         |
| `wagtaildocs`               | Wagtail Documentation                                  |For content designers to document how to use Wagtail.                                    |

# 2. Deployment Strategy – Blue-Green Deployment
### Applications Using Blue-Green Deployment:

* frontend

* wagtail

* search

* catalogue

* wagtaildocs

### What is Blue-Green Deployment?

* A strategy to reduce downtime and deployment risk by maintaining two identical environments:

* Blue (active) – currently serving production traffic

* Green (standby) – new version being deployed

### Deployment Process:

* Deploy the new version of the application to the Green environment while Blue continues serving traffic.

* Perform health checks on Green to ensure it is running correctly.

* Switch traffic from Blue → Green once Green is confirmed healthy.

* If any issues occur, traffic can quickly switch back to Blue (rollback).

### Notes for our setup:

* The script website-blue-green-deploy.sh is used for handling the Blue-Green switch.

* After deployment, CloudFront cache is invalidated so users immediately see the latest version.

* This approach is applied to all four applications, ensuring zero downtime and safe rollbacks.
# 3. Scripts Overview

All critical deployment scripts are located in:

`/usr/local/bin/`

## 3.1 startup.sh

**Purpose**: Full orchestration script for application and Traefik.

### Responsibilities:

* Sets environment variables from AWS Parameter Store 
   *  Frontend parameters path -> /application/web/frontend.
   * Wagtail parameters path -> /application/web/wagtail.
   * Catalogue parameters path -> /application/web/catalogue.
   * Search parameters path -> /application/web/search.
   * wagtaildocs parameters path -> /application/web/wagtaildocs.

* Installs dependencies (aws-cli, jq).

* Checks and updates Docker images for Traefik and frontend.

* Starts Traefik if not running.

* Triggers Blue-Green deployment via website-blue-green-deploy.sh.

* Invalidates CloudFront cache after deployment.

### Usage:
`sudo /usr/local/bin/startup.sh`

## 3.2 website-blue-green-deploy.sh

**Purpose**: Handles Blue-Green deployment for frontend (and similar logic applies to other apps).

### Responsibilities:

* Determines which container is currently active (Blue or Green).

* Starts the inactive container using Docker Compose.

* Performs health checks for the new container.

* Ensures Traefik recognizes the new container as healthy.

* Stops the previous active container after successful switch.

### Timeout & Retry:

* Timeout: 120 seconds

* Health check interval: 5 seconds


# 4. GitHub Actions Overview

All applications are deployed and managed via GitHub Actions workflows in the ds-infrastructure-web repository.

## 4.1 Deploy to Develop

**Trigger**:

* Push to main branch when config/develop.json changes.

* Manual trigger via workflow_dispatch.

**Jobs**:

* Deploy

* Runs on ubuntu-latest

* Environment: develop → https://dev-www.nationalarchives.gov.uk/

* Matrix deploys these services:

   * frontend

   * enrichment

   * wagtail

   * catalogue

   * search

* Fetches Docker images from Parameter Store (/application/web/<service>/docker_images)

* Updates deployed version in SSM (/application/web/<service>/deployed_version)

**Tests**

* Runs after deploy job

* Uses GH_TOKEN from ACTIONS_GITHUB_TOKEN_TEST_RUNNER secret

* Executes automated website tests against the develop environment

* Tests only run Mon–Fri, 09:00–17:00

* Slack notifications for failures

## 4.2 Release to Staging & Production

**Behavior**:

* Copies deployed values from develop to staging or production.

* Manual approval required before running:

* Approvers: Vaishnavi, Karl, Steven, AJ and James

## 4.3 Common Deployment Issues

* If any Action fails:

  * Identify which application failed.

  * Connect to the corresponding instance.

  * Run startup.sh manually:
  `sudo /usr/local/bin/startup.sh
`
  * If Blue-Green switch hangs (app not healthy), press CTRL+C.

  * Check logs:
   
    `sudo docker logs <container_name>`

  * Report the error to AJ – he will fix the code and push again.

* Most common issue is a failed deployment due to a code or image mismatch.

