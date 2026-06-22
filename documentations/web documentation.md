# **DS Infrastructure Web Documentation**

**⚠️ Note:** This document is regularly updated to reflect the changes. Please check for the latest version to ensure you have the most accurate information.

## **1. Overview**

The ds-infrastructure-web repository contains terraform configurations for migrating the **Etna** application from **Platform.sh** to **AWS**. This documentation provides a detailed guide on the architecture, deployment process, security practices, and recovery procedures.

## **2. Architecture**

![Architecture diagram](./general-web-infrastructure.draw.io)

## **3. Components**

**_Frontend_**
- Hosted on EC2 instances (`web-frontend`) in an Auto Scaling Group (ASG).
- Accessed via an Application Load Balancer.
- Uses AMI for deployment (web-frontend-primer\*).
- It serves user facing part of Etna application.

**_Enrichment_**
- Hosted on EC2 instances (`web-enrichment`) in an ASG.
- Uses AMI for deployment (web-enrichment-primer\*).
- The enrichment service is a backend component that processes and enhances data before it's delivered to users or other services.

**_Wagtail_**
- Wagtail refers to the **CMS(Content Management System)** component likely used to manage and serve content for Etna application.

**_Wagtaildocs_**
- Wagtaildocs is likely a component of the Wagtail CMS that manages document storage and retrieval.
- Hosted on EC2 instances (`web-wagtaildocs`).

**_Forms_**
- Hosted on EC2 instances (`web-forms`).

**_Search_**
- Hosted on EC2 instances (`web-search`).

**_Request-Service-Record_**
- Hosted on EC2 instances (`web-request-service-record`).

**_Catalogue_**
- Hosted on EC2 instances (`web-catalogue`).
- Currently reverse proxied from `beta-rp`.

**_Cognito_**
- Manages user authentication and authorization.
- Integrated with SES for email notifications.

**_Lambda Functions_**
- Used for deployment and startup scripts.

**_Elastic File System (EFS)_**
- Used for media storage.

**_Reverse Proxy_**
- Hosted on EC2 instances in an ASG.
- Uses AMI for deployment (web-reverse-proxy-primer\*).
- Configured with NGINX for routing traffic.

**_Security Groups_**
- Define network access rules for EC2 instances, ALBs and other resources.

**_IAM_**
- It is responsible for defining AWS permissions and roles to ensure secure access control for your infrastructure.

**_Cloud Front_**
- Cloud Front distribution acts as a secure CDN, caching content at edge locations and routing requests through AWS WAF before forwarding them to the reverse proxy ALB, using custom headers for origin authentication.

**_Route53_**
- Route53 is used for **DNS management** and **domain routing**, primarily to direct traffic to CloudFront distribution and other AWS services.

## **4. Deployment Process**

**_Prerequisites_**

- AWS account with necessary permissions.
- Terraform installed locally.
- Access to the ds-infrastructure-web repository.

This project uses **GitHub Actions** for CI/CD automation. Github Actions helps in automating the deployment process by running workflows defined in `.github/workflows/` .

For more details on our CI/CD pipleine, check our [GitHub Actions Workflow](https://github.com/nationalarchives/ds-infrastructure-web/actions).

**_Manual deployment Steps_**

**_1. Clone the repository_**:

```bash
git clone https://github.com/nationalarchives/ds-infrastructure-web.git
cd ds-infrastructure-web
```
Before initializing Terraform, copy the required variable files for the target environment into the Terraform working directory.

Example:

### Dev
```
cp -r _vars/dev/* .
```

### Staging
```
cp -r _vars/staging/* .
```

### Live
```
cp -r _vars/live/* .
```

## **Note**: 
After completing your Terraform operations, ensure that all copied variable and local files are removed from the Terraform working directory to avoid accidentally using the wrong environment configuration in subsequent runs.

```
rm -f *.auto.tfvars backend.tf
```

**_2. Initialise Terraform_**

```bash
terraform init
```

**_3. Terraform Plan_**

- Review the plan (additions, replacements and destroying of resources).

**_Development Plan_**

If you have already copied the required variable files into the Terraform working directory, run:
```
terraform plan
```
Otherwise, specify the required variable files explicitly:

```bash
terraform plan \
  -var-file="_vars/dev/autoscalinggroup.auto.tfvars" \
  -var-file="_vars/dev/frontend.auto.tfvars" \
  -var-file="_vars/dev/global.auto.tfvars" \
  -var-file="_vars/dev/route53.auto.tfvars" \
  -var-file="_vars/dev/media-efs.auto.tfvars" \
  -var-file="_vars/dev/cognito.auto.tfvars" \
  -var-file="_vars/dev/ses.auto.tfvars" \
  -var-file="_vars/dev/wagtail.auto.tfvars" \
  -var-file="_vars/dev/enrichment.auto.tfvars" \
  -var-file="_vars/dev/redis.auto.tfvars" \
  -var-file="_vars/dev/catalogue.auto.tfvars" \
  -var-file="_vars/dev/search.auto.tfvars" \
  -var-file="_vars/dev/wagtaildocs.auto.tfvars" \
  -var-file="_vars/dev/request-service-record.auto.tfvars" \
  -var-file="_vars/dev/forms.auto.tfvars" \
  -var-file="_vars/dev/reverse-proxy.auto.tfvars" \
  -var-file="_vars/dev/wp-website.auto.tfvars" \
  -var-file="_vars/dev/hosprec.auto.tfvars" \
  -var-file="_vars/dev/cloudfront.auto.tfvars" \
  -var-file="_vars/dev/environment.auto.tfvars" \
  -var-file="_vars/dev/waf.auto.tfvars" \
  -var-file="_vars/dev/waf-rules.auto.tfvars" \
  -var-file="_vars/dev/codedeploy.auto.tfvars"
```

**_Staging plan_**

If you have already copied the required variable files into the Terraform working directory, run:
```
terraform plan
```
Otherwise, specify the required variable files explicitly:

```bash
terraform plan \
  -var-file="_vars/staging/autoscalinggroup.auto.tfvars" \
  -var-file="_vars/staging/frontend.auto.tfvars" \
  -var-file="_vars/staging/global.auto.tfvars" \
  -var-file="_vars/staging/route53.auto.tfvars" \
  -var-file="_vars/staging/media-efs.auto.tfvars" \
  -var-file="_vars/staging/enrichment.auto.tfvars" \
  -var-file="_vars/staging/wagtail.auto.tfvars" \
  -var-file="_vars/staging/redis.auto.tfvars" \
  -var-file="_vars/staging/catalogue.auto.tfvars" \
  -var-file="_vars/staging/search.auto.tfvars" \
  -var-file="_vars/staging/wagtaildocs.auto.tfvars" \
  -var-file="_vars/staging/cognito.auto.tfvars" \
  -var-file="_vars/staging/ses.auto.tfvars" \
  -var-file="_vars/staging/request-service-record.auto.tfvars" \
  -var-file="_vars/staging/forms.auto.tfvars" \
  -var-file="_vars/staging/reverse-proxy.auto.tfvars" \
  -var-file="_vars/staging/wp-website.auto.tfvars" \
  -var-file="_vars/staging/hosprec.auto.tfvars" \
  -var-file="_vars/staging/cloudfront.auto.tfvars" \
  -var-file="_vars/staging/environment.auto.tfvars" \
  -var-file="_vars/staging/waf.auto.tfvars" \
  -var-file="_vars/staging/waf-rules.auto.tfvars" \
  -var-file="_vars/staging/codedeploy.auto.tfvars"
```

**_Live plan_**

If you have already copied the required variable files into the Terraform working directory, run:
```
terraform plan
```
Otherwise, specify the required variable files explicitly:

```bash
terraform plan \
-var-file="_vars/live/autoscalinggroup.auto.tfvars" \
-var-file="_vars/live/frontend.auto.tfvars" \
-var-file="_vars/live/global.auto.tfvars" \
-var-file="_vars/live/route53.auto.tfvars" \
-var-file="_vars/live/media-efs.auto.tfvars" \
-var-file="_vars/live/enrichment.auto.tfvars" \
-var-file="_vars/live/wagtail.auto.tfvars" \
-var-file="_vars/live/redis.auto.tfvars" \
-var-file="_vars/live/catalogue.auto.tfvars" \
-var-file="_vars/live/search.auto.tfvars" \
-var-file="_vars/live/wagtaildocs.auto.tfvars" \
-var-file="_vars/live/cognito.auto.tfvars" \
-var-file="_vars/live/ses.auto.tfvars" \
-var-file="_vars/live/request-service-record.auto.tfvars" \
-var-file="_vars/live/forms.auto.tfvars" \
-var-file="_vars/live/reverse-proxy.auto.tfvars" \
-var-file="_vars/live/wp-website.auto.tfvars" \
-var-file="_vars/live/hosprec.auto.tfvars" \
-var-file="_vars/live/cloudfront.auto.tfvars" \
-var-file="_vars/live/environment.auto.tfvars" \
-var-file="_vars/live/waf.auto.tfvars" \
-var-file="_vars/live/waf-rules.auto.tfvars" \
-var-file="_vars/live/codedeploy.auto.tfvars"
```

**_4. Apply Configuration_**

**_Development apply_**

If you have already copied the required variable files into the Terraform working directory, run:
```
terraform apply
```
Otherwise, specify the required variable files explicitly:

```bash
terraform apply \
  -var-file="_vars/dev/autoscalinggroup.auto.tfvars" \
  -var-file="_vars/dev/frontend.auto.tfvars" \
  -var-file="_vars/dev/global.auto.tfvars" \
  -var-file="_vars/dev/route53.auto.tfvars" \
  -var-file="_vars/dev/media-efs.auto.tfvars" \
  -var-file="_vars/dev/cloudfront.auto.tfvars" \
  -var-file="_vars/dev/cognito.auto.tfvars" \
  -var-file="_vars/dev/ses.auto.tfvars" \
  -var-file="_vars/dev/wagtail.auto.tfvars" \
  -var-file="_vars/dev/enrichment.auto.tfvars" \
  -var-file="_vars/dev/redis.auto.tfvars" \
  -var-file="_vars/dev/catalogue.auto.tfvars" \
  -var-file="_vars/dev/search.auto.tfvars" \
  -var-file="_vars/dev/wagtaildocs.auto.tfvars" \
  -var-file="_vars/dev/forms/auto.tfvars" \
  -var-file="_vars/dev/reverse-proxy.auto.tfvars" \
  -var-file="_vars/dev/wp-website.auto.tfvars" \
  -var-file="_vars/dev/hosprec.auto.tfvars" \
  -var-file="_vars/dev/cloudfront.auto.tfvars" \
  -var-file="_vars/dev/environment.auto.tfvars" \
  -var-file="_vars/dev/waf.auto.tfvars" \
  -var-file="_vars/dev/waf-rules.auto.tfvars" \
  -var-file="_vars/dev/codedeploy.auto.tfvars"
```

**_Staging apply_**

If you have already copied the required variable files into the Terraform working directory, run:
```
terraform apply
```
Otherwise, specify the required variable files explicitly:

```bash
terraform apply \
  -var-file="_vars/staging/autoscalinggroup.auto.tfvars" \
  -var-file="_vars/staging/frontend.auto.tfvars" \
  -var-file="_vars/staging/global.auto.tfvars" \
  -var-file="_vars/staging/route53.auto.tfvars" \
  -var-file="_vars/staging/media-efs.auto.tfvars" \
  -var-file="_vars/staging/enrichment.auto.tfvars" \
  -var-file="_vars/staging/wagtail.auto.tfvars" \
  -var-file="_vars/staging/redis.auto.tfvars" \
  -var-file="_vars/staging/catalogue.auto.tfvars" \
  -var-file="_vars/staging/search.auto.tfvars" \
  -var-file="_vars/staging/wagtaildocs.auto.tfvars" \
  -var-file="_vars/staging/cognito.auto.tfvars" \
  -var-file="_vars/staging/ses.auto.tfvars" \
  -var-file="_vars/staging/request-service-record.auto.tfvars" \
  -var-file="_vars/staging/forms.auto.tfvars" \
  -var-file="_vars/staging/reverse-proxy.auto.tfvars" \
  -var-file="_vars/staging/wp-website.auto.tfvars" \
  -var-file="_vars/staging/hosprec.auto.tfvars" \
  -var-file="_vars/staging/cloudfront.auto.tfvars" \
  -var-file="_vars/staging/environment.auto.tfvars" \
  -var-file="_vars/staging/waf.auto.tfvars" \
  -var-file="_vars/staging/waf-rules.auto.tfvars" \
  -var-file="_vars/staging/codedeploy.auto.tfvars"
```

**_Live apply_**

If you have already copied the required variable files into the Terraform working directory, run:
```
terraform apply
```
Otherwise, specify the required variable files explicitly:

```bash
terraform apply \
-var-file="_vars/live/autoscalinggroup.auto.tfvars" \
-var-file="_vars/live/frontend.auto.tfvars" \
-var-file="_vars/live/global.auto.tfvars" \
-var-file="_vars/live/route53.auto.tfvars" \
-var-file="_vars/live/media-efs.auto.tfvars" \
-var-file="_vars/live/enrichment.auto.tfvars" \
-var-file="_vars/live/wagtail.auto.tfvars" \
-var-file="_vars/live/redis.auto.tfvars" \
-var-file="_vars/live/catalogue.auto.tfvars" \
-var-file="_vars/live/search.auto.tfvars" \
-var-file="_vars/live/wagtaildocs.auto.tfvars" \
-var-file="_vars/live/cognito.auto.tfvars" \
-var-file="_vars/live/ses.auto.tfvars" \
-var-file="_vars/live/request-service-record.auto.tfvars" \
-var-file="_vars/live/forms.auto.tfvars" \
-var-file="_vars/live/reverse-proxy.auto.tfvars" \
-var-file="_vars/live/wp-website.auto.tfvars" \
-var-file="_vars/live/hosprec.auto.tfvars" \
-var-file="_vars/live/cloudfront.auto.tfvars" \
-var-file="_vars/live/environment.auto.tfvars" \
-var-file="_vars/live/waf.auto.tfvars" \
-var-file="_vars/live/waf-rules.auto.tfvars" \
-var-file="_vars/live/codedeploy.auto.tfvars"
```

**_5. Verify Deployment_**

- Check AWS console for resources.

## **5. Terraform Configuration**

**_File Structure_**

- `backend.tf`: Configures the S3 bucket for terraform state.
- `cognito.tf`: Manages Cognito user pools and clients.
- data-ami.tf: Defines AMIs for EC2 instances.
- `data.tf`: Retrieves SSM Parameters and secrets.
- `web-enrichment.tf`: Configures the enrichment service.
- `web-frontend.tf`: Configures the frontend service.
- `web-catalogue.tf`: Configures the catalogue service.
- `web-wagtaildocs.tf`: Configures the wagtail docs service.
- `web-forms.tf`: Configures the forms service.
- `web-request-service-record.tf`: Configures the Request a Military Record service.
- `lambda.tf`: Manages lambda functions and layers.
- `media-efs.tf`: Configures EFS and backups.
- `iam.tf`: Defines IAM roles and policies.
- `provider.tf`: Configures terraform providers (AWS and klayers).
- `security-groups.tf`: Defines security groups for network access.
- `web-wagtail.tf`: Configures the wagtail CMS service.
- `global-variables.tf`: Defines global variables and tags used across all Terraform modules.
- `waf.tf`: Configures AWS WAF (Web Application Firewall) to protect web services from common exploits (SQL injection, XSS, DDoS).
- `web-reverse-proxy.tf`: Configures the NGINX reverse proxy service that routes and filters traffic between CloudFront and backend services.

**_Best Practices_**

- Use modules for reusable components.
- Add comments and documentation to Terraform code.
- Validate Terraform configurations with `terraform validate`.

## **6. Security Best Practices**

**_IAM Roles and Policies_**

- Follow the principle of least privilege.

**_Secrets Management_**

- Store secrets in AWS Secrets or Parameter store.
- Rotate secrets regularly.

**_Network Security_**

- Use security groups to restrict access to resources.
- Ensure public facing resources are properly secured.

## **7. Backup and Retention policies**

**EFS Backups**

- **Schedule**: Daily Backups.
- **Retention**: 30 days.
- **Cold storage**: After 7 days.
- **Deletion**: After 90 days.

**Terraform State**

- Enable versioning for the S3 bucket.
- Use state locking to prevent conflicts.

## **8. Troubleshooting**

**Common Issues**

1. **Terraform Apply fails**:

- Check for syntax errors in terraform files.
- Validate AWS permissions.
- Resources already existing.

2. **Lambda Function Fails**:

- Check CloudWatch logs for errors.
- Validate IAM permissions.

3. **EFS Backup fails**:

- Verify backup configuration in AWS Backup.
- Check IAM permissions for AWS Backup.
