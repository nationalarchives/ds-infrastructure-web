DS Infrasructure Web Documentation

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





