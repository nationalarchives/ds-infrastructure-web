## Create Domain for Wagtail in AWS and Configure Nameservers

### 1. Create Hosted Zone in AWS Route 53

1. Log in to the **AWS Management Console**.
2. Go to **Route 53** → **Hosted Zones**.
3. Click on **"Create hosted zone"**.
4. Fill in the details:
   - **Domain name**:
   * Dev- `dev-wagtail.nationalarchives.gov.uk`
   * Staging-`staging-wagtail.nationalarchives.gov.uk`
   * Live-`wagtail.nationalarchives.gov.uk`
   - **Type**: Public Hosted Zone
5. Click **"Create hosted zone"**.

Once created, AWS will automatically generate **4 NS (Name Server)** records for the hosted zone.

---

### 2. Update Nameservers in TotalUp (Domain Registrar)

1. Log in to the **TotalUp** portal (your domain registrar).
2. Go to the domain management section for `nationalarchives.gov.uk`.
3. Locate the DNS or Nameserver settings.
4. Add the existing nameservers with the **4 NS records** provided by AWS Route 53.
   - Copy the NS values exactly as shown in the Route 53 hosted zone.
5. Save the changes.

> ✅ **Note:** DNS propagation may take up to 24–48 hours, but usually completes much sooner.

---

### 3. Verify Hosted Zone Setup

Once the nameservers are updated, verify that the hosted zone is correctly set up by running:

```bash
dig dev-wagtail.nationalarchives.gov.uk NS
dig staging-wagtail.nationalarchives.gov.uk NS
dig wagtail.nationalarchives.gov.uk NS
```

## Set Up CloudFront Distribution for Wagtail Domain

### 1. Open CloudFront in AWS Console

1. Go to the **AWS Management Console**.
2. Navigate to **CloudFront** → **Distributions**.
3. Click on **"Create Distribution"**.

---

### 2. Configure Distribution Settings

- **Origin domain**: Enter the public DNS or Load Balancer URL pointing to your Wagtail instance (e.g., `website-reverse-proxy-dev-lb-1371968452.eu-west-2.elb.amazonaws.com
` or similar).
- **Origin protocol policy**: `HTTPS only`
- **Viewer protocol policy**: `Redirect HTTP to HTTPS`
- **Allowed HTTP methods**: Select `GET, HEAD` (or choose others if needed).
- **Cache policy**: Choose `CachingOptimized` (or your custom policy).

---

### 3. Add Alternate Domain Name (CNAME)

- **Alternate domain name (CNAME)**:  
  Add `dev-wagtail.nationalarchives.gov.uk` for dev and similarly for staging and live

---

### 4. Attach SSL Certificate

- **Custom SSL certificate (
  \*.nationalarchives.gov.uk)**:  
   Choose the certificate for `dev-wagtail.nationalarchives.gov.uk` for dev and other environments from **ACM** (AWS Certificate Manager).

---

### 5. Complete the Setup

- Click **Create Distribution**.
- Wait for the status to become **“Deployed”** (may take a few minutes).

---

### 6. Update DNS in Route 53

1. Go back to **Route 53** → hosted zone for `dev-wagtail.nationalarchives.gov.uk`in dev and other environments.
2. Click **"Create Record"**.
3. Add an **A Record (Alias)** pointing to the CloudFront distribution:
   - **Record name**: `dev-wagtail.nationalarchives.gov.uk` for dev and similarly for staging and live
   - **Record type**: `A - IPv4 address`
   - **Alias**: Yes
   - **Alias target**: Select your CloudFront distribution from the dropdown.

4. Click **Create records**.

---

### 7. Verify

After DNS propagation (a few minutes to hours):

```bash
curl -I https://dev-wagtail.nationalarchives.gov.uk
curl -I https://staging-wagtail.nationalarchives.gov.uk
curl -I https://wagtail.nationalarchives.gov.uk
```

## Configure NGINX Reverse Proxy for Wagtail on website-reverse-proxy-dev

Update the NGINX configuration to route Wagtail requests (`admin`, `static`, and `media`) through the reverse proxy.

**1. Connect to the Reverse Proxy Server:**
Connect to the `website-reverse-proxy` instance via session manager.

**2. Edit NGINX Configuration**:

Open the NGINX config file:

```bash
 sudo vi /etc/nginx/nginx.conf
```

**3. Add a Server Block for `dev-wagtail.nationalarchives.gov.uk`**:
Inside the http block or in the respective site config, add server block for the domain. (Refer the code in the instance).

**4. Test and Reload NGINX**:
After editing

    ```bash
    sudo nginx -t
    sudo systemctl -s reload
    ```

**5. Verify Setup**

Open the browser and go to:

For Dev:

http://dev-wagtail.nationalarchives.gov.uk/admin/login/

http://dev-wagtail.nationalarchives.gov.uk/static/

http://dev-wagtail.nationalarchives.gov.uk/media/imagename

For Staging:

http://staging-wagtail.nationalarchives.gov.uk/admin/login/

http://staging-wagtail.nationalarchives.gov.uk/media/imagename

http://staging-wagtail.nationalarchives.gov.uk/static

For Live:

http://wagtail.nationalarchives.gov.uk/admin/login/

http://wagtail.nationalarchives.gov.uk/media/imagename

http://wagtail.nationalarchives.gov.uk/static/

- Make sure all routes are properly working in all environments
