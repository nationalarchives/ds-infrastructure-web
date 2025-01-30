# ds-infrastructure-web

## Requisites
### Create AMI for Reverse Proxy Server
The AMI is the base for the reverse proxy using NginX without configuring any settings. The require settings are loaded at startup and restart from a S3 bucket.
This process is in place to allow autoscalling picking up changes without rebuild and deployment of a new AMI.
### Create AMI for Frontend Application Server
### Apply Infrastructure to AWS
Before a successful ```terraform apply``` can be run following requisites need to be in place.
* Run ```terraform apply``` on **ds-infrastructure-web**
* Add values manually to _Systems Manager Parameter Store_
* Add values manually to _Secrets Manager_
* Create several AMIs in **ds-ami-build**
### ds-infrastructure
Running ```terraform apply``` on **ds-infrastructure-web** will create most of the basic networking and services on which private web will run.
### Database
The private web installation depends on the existence of a PostgreSQL database.
It is highly recommended to run at least one replica in the live environment.
Use the GitHub Action in **ds-ami-build** repo to prepare the ami(s) which will be use during ```terraform apply``` on **ds-infrastructure-web  **.
### Systems Manager Parameter Store
Most values required will me set during ```terraform apply``` in **ds-infrastructure-web**.
Following values would need to be stored manually in the _Systems Manager Parameter Store_:
* /application/web/frontend/waf/ip_set - comma separated string containing either a list of allowed or blocked IP address ranges in CIDR notation.
* /infrastructure/certificate-manager/wildcard-certificate-arn - containing the certificate arn for the valid wildcard certificate; might have been put in place by other application installations.
* /infrastructure/certificate-manager/us-east-1-wildcard-certificate-arn - wildcard certificate used by CloudFront; similar to the wildcard certificate for the domain above.
### Secrets Manager
This are database or other secrets which are confidential and should not be saved in a repository.
### AMI builds
Please read any documentation in the **ds-ami-build** repo in regards of the required build for further information.
* NginX instance - web-rp-primer*
* Wagtail instance - web-frontend-primer*
### Sharing public files
Public files uploaded to the web side are stored on EFS which is shared between the reverse proxy and Frontend instances. The mounting point for RP is _/var/nationalarchives.gov.uk_ and for Frontend _/app_ \
There is no fixed directory structure in place but it is recommended to follow use root directories for the file families \
/css - all css files \
/js - all js files \
/media - all images and media files \
/error-pages - all error pages which are triggered from NginX \
