**DS Infrasructure Web Documentation**

**1. Overview**

The ds-infrastructure-web repository contains terraform configurations for migrating the **Etna** application from **Platform.sh** to **AWS**. This documentation provides a detailed guide on the architecture, deployment process, security practices, and recovery procedures.

**2. Architecture**

 

 **3. Components**

 ***Frontend***

 * Hosted on EC2 instances in an Auto Scaling Group (ASG).
 * Accessed via an Application Load Balancer.
 * Uses AMI for deployment (web-frontend-primer*).
 * It serves user facing part of Etna application.

 ***Enrichment***

 * Hosted on EC2 instances in an ASG.
 * Uses AMI for deployment (web-enrichment-primer*).
 * The enrichment service is a backend component that processes and enhances data before it's delivered to users or other services.

 ***Cognito***

 * Manages user authentication and authorization.
 * Integrated with SES for email notifications.

 ***Lambda Functions***
 * Used for deployment and startup scripts.

 ***Elastic File System (EFS)***
 * Used for media storage.

 ***Reverse Proxy***
 * Hosted on EC2 instances in an ASG.
 * Uses AMI for deployment (web-rp-primer*).
 * Configured with NGINX for routing traffic.

 ***Security Groups***
 
 * Define network access rules for EC2 instances, ALBs and other resources.

 ***IAM***

 * It is responsible for defining AWS permissions and roles to ensure secure access control for your infrastructure.

 ***Cloud Front***

 * Cloud Front distribution acts as a secure CDN, caching content at edge locations and routing requests through AWS WAF before forwarding them to the reverse proxy ALB, using custom headers for origin authentication.

 ***Wagtail***

 * Wagtail refers to the **CMS(Content Management System)** component likely used to manage and serve content for Etna application.

 ***Route53***

 * Route53 is used for **DNS management** and **domain routing**, primarily to direct traffic to CloudFront distribution and other AWS services.   


**3. Deployment Process**

***Prerequisites***

* AWS account with necessary permissions.
* Terraform installed locally.
* Access to the ds-infrastructure-web repository.

***Steps***

***1. Clone the repository***:

```bash
git clone https://github.com/nationalarchives/ds-infrastructure-web.git
cd ds-infrastructure-web
```

***2. Initialise Terraform***

```bash
terraform init
```

***3. Terraform Plan***
* Review the plan (additions, replacements and destroying of resources).

***Development Plan***
```bash
terraform plan \
  -var-file="../../vars/dev/terraform/autoscalinggroup.auto.tfvars" \
  -var-file="../../vars/dev/terraform/frontend.auto.tfvars" \
  -var-file="../../vars/dev/terraform/global.auto.tfvars" \
  -var-file="../../vars/dev/terraform/nginx-conf.auto.tfvars" \
  -var-file="../../vars/dev/terraform/reverse-proxy.auto.tfvars" \
  -var-file="../../vars/dev/terraform/waf.auto.tfvars" \
  -var-file="../../vars/dev/terraform/route53.auto.tfvars" \
  -var-file="../../vars/dev/terraform/media-efs.auto.tfvars" \
  -var-file="../../vars/dev/terraform/cloudfront.auto.tfvars" \
  -var-file="../../vars/dev/terraform/cognito.auto.tfvars" \
  -var-file="../../vars/dev/terraform/ses.auto.tfvars" \
  -var-file="../../vars/dev/terraform/wagtail.auto.tfvars" \
  -var-file="../../vars/dev/terraform/enrichment.auto.tfvars"
  ```

***Staging plan***

```bash
terraform plan \
  -var-file="../../vars/staging/terraform/autoscalinggroup.auto.tfvars" \
  -var-file="../../vars/staging/terraform/frontend.auto.tfvars" \
  -var-file="../../vars/staging/terraform/global.auto.tfvars" \
  -var-file="../../vars/staging/terraform/nginx-conf.auto.tfvars" \
  -var-file="../../vars/staging/terraform/reverse-proxy.auto.tfvars" \
  -var-file="../../vars/staging/terraform/waf.auto.tfvars" \
  -var-file="../../vars/staging/terraform/route53.auto.tfvars" \
  -var-file="../../vars/staging/terraform/media-efs.auto.tfvars" \
  -var-file="../../vars/staging/terraform/cloudfront.auto.tfvars" \
  -var-file="../../vars/staging/terraform/enrichment.auto.tfvars" \
  -var-file="../../vars/staging/terraform/wagtail.auto.tfvars" \
  -var-file="../../vars/staging/terraform/cognito.auto.tfvars" \
  -var-file="../../vars/staging/terraform/ses.auto.tfvars"
  ```

  ***Live plan***

  ```bash
  terraform plan \
  -var-file="../../vars/live/terraform/autoscalinggroup.auto.tfvars" \
  -var-file="../../vars/live/terraform/frontend.auto.tfvars" \
  -var-file="../../vars/live/terraform/global.auto.tfvars" \
  -var-file="../../vars/live/terraform/nginx-conf.auto.tfvars" \
  -var-file="../../vars/live/terraform/reverse-proxy.auto.tfvars" \
  -var-file="../../vars/live/terraform/waf.auto.tfvars" \
  -var-file="../../vars/live/terraform/route53.auto.tfvars" \
  -var-file="../../vars/live/terraform/media-efs.auto.tfvars" \
  -var-file="../../vars/live/terraform/cloudfront.auto.tfvars" \
  -var-file="../../vars/live/terraform/enrichment.auto.tfvars" \
  -var-file="../../vars/live/terraform/wagtail.auto.tfvars" \
  -var-file="../../vars/live/terraform/cognito.auto.tfvars" \
  -var-file="../../vars/live/terraform/ses.auto.tfvars"
  ```

***4. Apply Configuration***

***Development apply***

```bash
terraform apply \
  -var-file="../../vars/dev/terraform/autoscalinggroup.auto.tfvars" \
  -var-file="../../vars/dev/terraform/frontend.auto.tfvars" \
  -var-file="../../vars/dev/terraform/global.auto.tfvars" \
  -var-file="../../vars/dev/terraform/nginx-conf.auto.tfvars" \
  -var-file="../../vars/dev/terraform/reverse-proxy.auto.tfvars" \
  -var-file="../../vars/dev/terraform/waf.auto.tfvars" \
  -var-file="../../vars/dev/terraform/route53.auto.tfvars" \
  -var-file="../../vars/dev/terraform/media-efs.auto.tfvars" \
  -var-file="../../vars/dev/terraform/cloudfront.auto.tfvars" \
  -var-file="../../vars/dev/terraform/cognito.auto.tfvars" \
  -var-file="../../vars/dev/terraform/ses.auto.tfvars" \
  -var-file="../../vars/dev/terraform/wagtail.auto.tfvars" \
  -var-file="../../vars/dev/terraform/enrichment.auto.tfvars"
  ```

  ***Staging apply***

  ```bash
  terraform apply \
  -var-file="../../vars/staging/terraform/autoscalinggroup.auto.tfvars" \
  -var-file="../../vars/staging/terraform/frontend.auto.tfvars" \
  -var-file="../../vars/staging/terraform/global.auto.tfvars" \
  -var-file="../../vars/staging/terraform/nginx-conf.auto.tfvars" \
  -var-file="../../vars/staging/terraform/reverse-proxy.auto.tfvars" \
  -var-file="../../vars/staging/terraform/waf.auto.tfvars" \
  -var-file="../../vars/staging/terraform/route53.auto.tfvars" \
  -var-file="../../vars/staging/terraform/media-efs.auto.tfvars" \
  -var-file="../../vars/staging/terraform/cloudfront.auto.tfvars" \
  -var-file="../../vars/staging/terraform/cognito.auto.tfvars" \
  -var-file="../../vars/staging/terraform/ses.auto.tfvars" \
  -var-file="../../vars/staging/terraform/wagtail.auto.tfvars" \
  -var-file="../../vars/staging/terraform/enrichment.auto.tfvars"
  ```

  ***Live apply***

  ```bash
  terraform apply \
  -var-file="../../vars/live/terraform/autoscalinggroup.auto.tfvars" \
  -var-file="../../vars/live/terraform/frontend.auto.tfvars" \
  -var-file="../../vars/live/terraform/global.auto.tfvars" \
  -var-file="../../vars/live/terraform/nginx-conf.auto.tfvars" \
  -var-file="../../vars/live/terraform/reverse-proxy.auto.tfvars" \
  -var-file="../../vars/live/terraform/waf.auto.tfvars" \
  -var-file="../../vars/live/terraform/route53.auto.tfvars" \
  -var-file="../../vars/live/terraform/media-efs.auto.tfvars" \
  -var-file="../../vars/live/terraform/cloudfront.auto.tfvars" \
  -var-file="../../vars/live/terraform/enrichment.auto.tfvars" \
  -var-file="../../vars/live/terraform/wagtail.auto.tfvars" \
  -var-file="../../vars/live/terraform/cognito.auto.tfvars" \
  -var-file="../../vars/live/terraform/ses.auto.tfvars"
  ```

  ***5. Verify Deployment***

  * Check AWS console for resources.
