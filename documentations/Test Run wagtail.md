# Test Run Wagtail Migration
### Download Media from Wagtail

1. **Create a Directory:**
   First, create a directory called `wagtail-content` under the `~/temp/` directory.

   ```bash
   mkdir ~/temp/wagtail-content
   ```

2. **Open the Directory:** Change into the newly created wagtail-content directory.

   ```bash
   cd ~/temp/wagtail-content
   ```
3. **Download Media:** To download the media files, use the platform mount:download command with the appropriate options. This will mount the media and download the files to your current directory.

   ``` bash
   platform mount:download --mount media --target .
   ```   
* This will download the media files into the `~/temp/wagtail-content` directory.

### Zip the Downloaded Files

1. **Zip the Files:**
   After downloading the media files into the `~/temp/wagtail-content` directory, you can compress the contents into a `.zip` file using the `zip` command.

   ```bash
   zip -r wagtail-content.zip .
   ```
* This will create a `wagtail-content.zip` file containing all the files in the current directory.
### Upload the Zip File to an S3 Bucket

1. **Set up AWS CLI:**
   Ensure that you have the AWS CLI installed and configured with the appropriate credentials.

   You can configure it using:

   ```bash
   aws configure
   ```
2. **Upload the Zip File to S3:** Use the aws s3 cp command to upload the wagtail-content.zip file to the `ds-dev-deployment-source` S3 bucket. Replace <bucket-name> with your actual S3 bucket name if different.

   ``` bash
   aws s3 cp wagtail-content.zip s3://ds-dev-deployment-source/
   ```
* This command uploads the `wagtail-content.zip` file to the specified S3 bucket.

3. **Verify the Upload:** You can verify that the file has been uploaded to the S3 bucket by listing the contents:

   ```bash
   aws s3 ls s3://ds-dev-deployment-source/
   ```
* This will display the files in the `ds-dev-deployment-source` bucket, confirming that your zip file is successfully uploaded.

### Copy the Zip File to Wagtail Instance's /app/media Directory

1. **Connect to the Wagtail Instance:**
   Use Session Manager to connect to the Wagtail instance where you want to copy the zip file. 

2. **Download the Zip File from S3 Directly to /app/media:** Once you're connected to the Wagtail instance, use the AWS CLI to download the wagtail-content.zip file directly to the /app/media directory on the instance.

    ``` bash
    aws s3 cp s3://ds-dev-deployment-source/wagtail-content.zip /app/media/
    ```
* This command will download the zip file directly into the `/app/media` directory.

3. **Extract the Zip File in /app/media:** After downloading the file, extract the contents of the zip file into the `/app/media` directory.

     ```bash
    sudo unzip /app/media/wagtail-content.zip -d /app/media
    ```
* This will unzip the contents directly into the `/app/media` directory.

4. **Verify the Files:** Check the `/app/media` directory to ensure the files were copied successfully.

      ```bash
      ls /app/media
    ```
* This will list the files in the `/app/media` directory, confirming that the files from the zip have been extracted properly.

### Update Wagtail Content-Related Parameters in AWS Parameter Store

1. **Identify Content-Related Parameters:**
   Locate all parameters in AWS Systems Manager (SSM) Parameter Store that are related to Wagtail or `platform.sh` content setup.
2. **Update the Parameters in Parameter Store:** For each relevant parameter, update it with Wagtail-specific values.
3. **Restart the web-frontend service**:

   ***Stop and Remove Existing Containers:***
   ``` bash
   sudo docker ps -a
   sudo docker stop <container-id>
   sudo docker rm <container-id>
   ```
   ***Run the startup script***
   * This will reload environment variables from the Parameter Store and reinitialize the containers.

      ```bash
      startup.sh
      ```
4. **Verify Application Behavior:** Check the container logs and access the application to confirm the Wagtail content is working correctly.

     ``` bash
     sudo docker ps
     sudo docker logs <container-name>
     ```





