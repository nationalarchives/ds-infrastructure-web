# AWS Parameter Store Configuration and GitHub Actions Integration

This document outlines the paths for storing parameters in AWS Systems Manager Parameter Store for different services in the application and how the parameters are updated automatically using GitHub Actions.

The environment variables related to the web-frontend, web-enrichment, and wagtail services are stored under separate paths in the Parameter Store, and updates are handled through automated processes when Docker images are updated.

## 1. Parameter Paths in AWS Parameter Store

The following paths in AWS Parameter Store store the environment variables for different components of the application:

### 1.1 Web Frontend Parameters

The web frontend related environment variables are stored under the path:

```bash
/application/web/frontend/
```

### 1.2 Web Enrichment Parameters

The web enrichment related environment variables are stored under the path:

```bash
/application/web/enrichment
```

### 1.3 Wagtail Parameters

The wagtail related environment variables are stored under the path:

```bash
/application/web/wagtail
```

## 2. Updating Parameters in AWS Parameter Store

### 2.1 GitHub Actions for Automatic Updates

When the Docker image version is updated in any of the JSON files (e.g., develop.json, staging.json, production.json), a GitHub Action is triggered. This GitHub Action updates the corresponding parameters in AWS Parameter Store.

### 2.1.1 Workflow for Updating Parameters

**1.Triggering the Update:**

- The `deploy-to-develop` workflow is triggered when a change is pushed to the develop.json file located in the config directory.

- The `Release-to-staging` workflow is triggered when a change is pushed to the staging.json file located in the config directory.

- The `Release-to-production` workflow is triggered when a change is pushed to the production.json file located in the config directory.

**2.Reading Configuration Files:**

The actions read the updated JSON file to retrieve the Docker image versions.

**3. Updating AWS Parameter Store:**

The GitHub Actions then update the parameters in AWS Parameter Store with the new Docker image versions for each service.

# 3. AWS Lambda Trigger

## 3.1 Lambda Function Trigger

Once the parameters are updated in the AWS Parameter Store, the following steps occur:

### 1. Detecting the Update:

- The AWS Lambda function is set up to monitor changes in the AWS Parameter Store using AWS EventBridge.

- When a new version of a parameter (such as the Docker image) is pushed to Parameter Store (for example, for the frontend service), the Lambda function is triggered.

### 2. Triggering the startup.sh Script:

- The Lambda function checks the updated parameters for the relevant service and determines which instances need to pull the new Docker image.

- Once identified, the Lambda function triggers the startup.sh script on the web-frontend instance (or any other service instance) to pull the latest Docker image and restart the service.

- The startup.sh script performs the following:

- It checks the AWS Parameter Store for the latest image version.

- It pulls the updated Docker image from the registry.

- It restarts the Docker container with the latest image.

### 3. Automatic Deployment:

After the startup.sh script executes, the updated Docker image is deployed automatically, and the service is running with the latest version.
