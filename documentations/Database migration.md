## **Steps to Log In to Platform.sh via Terminal**:

1. **Open Terminal**:

* Open the terminal on your local machine to start the login process.

2. **Run the `platform login` Command**:

* To log in, use the following command:

    ``` bash 
    platform login
    ```

* This command triggers the authentication process.

3. **Login in Your Browser**:

* After running the command, a login screen will appear in your default web browser.

* Enter your Platform.sh account credentials (username and password) to authenticate your session.

4. **Authorization Completion**:

* After successfully logging in, the CLI will automatically authorize your session, and you will see a confirmation in the terminal.

5. **Start Using Platform.sh CLI**:

* Once authorized, you can now use Platform.sh CLI commands to manage your projects and resources on Platform.sh.

## **Steps to Dump the Database**:

1. **Run the Database Dump Command**:

* In your terminal, run the following command:

   ``` bash
   platform db:dump
  ```


2. **Choose the Project**:

* When prompted to select the project, you'll see a list of available projects.

* You will be asked to select a project by entering the number corresponding to your project.

3. **Select the Wagtail Project**:

* Our project is Etna Wagtail, type the number corresponding to Etna Wagtail-Project and hit Enter.

4. **Choose the Environment**:

* After choosing the project, you'll be asked to select the environment.

* You will see a list of available environments for that project, which could include development, staging, production, etc.

* To select production, type the number corresponding to production and hit Enter.

5. **Database Dump**:

* After choosing the project and environment, the database dump process will begin, and you can follow the prompts to complete it. By default, the dump file will be saved in the directory from which you run the command.

* The exact name and format may vary depending on your configuration, but you can expect a .sql file.

6. **Verify the dump location**:

* After the dump is created, you can list the files in the current directory to confirm:

     ``` bash
      ls 
    ```

* You should see the dump file listed there.


## **Steps to Identify PostgreSQL Servers in AWS Console**:

1. **Log in to the AWS Console**:

* Open your browser and go to the AWS Management Console.

* Enter your credentials to log in.

2. **Navigate to EC2 Dashboard**:

* In the Services menu, type EC2 and select EC2 to open the EC2 dashboard.

3. **Check the Running Instances**:

* In the left-hand menu, click on Instances under the Instances section to view all the EC2 instances running.

* You will see a list of all EC2 instances along with their names, instance IDs, types, and statuses.

4. **Identify PostgreSQL Instances**:

* Look for instances named `postgres-main-prime` and `postgres-main-replica`.

* `postgres-main-prime` is most likely the primary database server.

* `postgres-main-replica `is the replica server.

5. **Connect to the VPN**
* Connect to VPN successfully and proceed with next steps.

## **Steps to Connect pgAdmin 4 to PostgreSQL Instance**:

1. **Open pgAdmin 4**:

* Launch pgAdmin 4 from your system or via your browser (if using the web version).

2. **Add a New Server in pgAdmin**:

* In pgAdmin, on the left sidebar, right-click on Servers and select Create > Server....

3. **Fill in the Server Details**: In the Create - Server window, you'll need to provide the following details:

* **General Tab**:

  * Name: Give a name to your connection (e.g., Postgres Main Prime).

* **Connection Tab**:

  * **Host name/address**: Enter the hostname for your PostgreSQL server. In our case, it is postgres-main-prime.dev.local.

  * **Port**: The default PostgreSQL port is 5432, but if your instance uses a different port, provide that.

  * **Maintenance database**: Enter the name of the database you want to connect to (e.g., etna)

  * **Username**: Provide the PostgreSQL username (Get the details from secret manager).

  * **Password**: Enter the password for the PostgreSQL user.

4. **Save and Connect**:

* After filling out the connection details, click Save.

* You should now see your server listed under Servers in pgAdmin.

5. **Test the Connection**:

* Once the server is added, you can expand the connection, navigate through databases, and start querying your PostgreSQL instance.

## **Upload the PostgreSQL dump file to the postgres-main-prime instance**

1. **Connect to the PostgreSQL Instance**
* Connect to the instance via session manager.

2. **Navigate to the Root Directory and Check /tmp**

* Once inside the server:

    ``` bash
    cd /

    ls

   ls tmp
   ```

* This ensures that the /tmp directory is accessible and can store the database dump.

3. **Copy the Dump File from S3 to the Server**

* Use the following command to copy the dump file from the S3 bucket to the PostgreSQL instance:

   ``` bash 
   aws s3 cp s3://ds-dev-deployment-source/databases/postgres/<dumpfilename.sql>  /tmp/etna.sql
  ```

* 🔹 Replace <dumpfilename.sql> with the actual dump file name.

* This will download the file into /tmp/etna.sql on the instance.

4. **Verify the Dump File**

* After the file is copied, confirm that it exists in /tmp:

    ``` bash
    ls -lh /tmp/etna.sql
    ```

* If the file is listed, you're good to proceed with the database restoration.

### **Create a Database Dump using pg_dump**
* Run the following command to create a compressed dump of the etna database:

  ``` bash
  sudo pg_dump -U postgres -Fc etna > /tmp/etna.sql
  ```

  🔹 PostgreSQL will prompt for a password.

* The password is stored in AWS Secrets Manager.

* Go to AWS Console → Secrets Manager and find the secret containing PostgreSQL credentials.

* Copy the password and paste it when prompted.

### **Verify the Dump File**

* After the command completes, check if the dump file is created:

  ``` bash 
  pg_dump -U postgres -Fc etna > /tmp/etna.dump
  ```

### **Verify the Second Dump File**

* Check if both etna.sql and etna.dump exist in /tmp/:

   ``` bash 
   ls -lh /tmp/
   ```

* You should now see both etna.sql and etna.dump.

### **Delete the Existing etna Database in pgAdmin 4**

* Open pgAdmin 4 and connect to the PostgreSQL server.

* In the left sidebar, navigate to the Databases section.

* Right-click on the etna database and select Delete/Drop.

* Confirm the deletion when prompted.

### Connect to the instance

* Once connected, run the following command to log into PostgreSQL:

   ``` bash
   psql -U postgres
   ```

* You will be prompted for a password. Copy the password from AWS Secrets Manager and paste it when prompted.

### Create the New Database (etna)
* Once you are inside the PostgreSQL shell, run the following commands:

  -- Create the new database 'etna' with the owner 'etna_app_user'

   ``` bash 
   createdb -O etna_app_user etna;
  ```
* This command will create the etna database and assign the etna_app_user as the owner.

### Refresh Databases in pgAdmin 4
* After creating the database on the instance, go back to pgAdmin 4.

* In the Databases section, right-click and select "Refresh".

* You should now see the newly created etna database listed in the databases.

### Exit the PostgreSQL Shell
* To exit from the PostgreSQL shell, simply type:

   ``` bash
   \q
  ```

### Run the pg_restore Command to Restore the Database
* Now that you're back in the shell, use the following command to restore the dump:

  ``` bash 
  pg_restore -U postgres -d etna -f /tmp/etna.dump
  ```

* This will restore the contents of etna.dump into the etna database.

* -U postgres: Specifies the PostgreSQL user to connect with (postgres in this case).

* -d etna: Specifies the database to restore into (etna).

* -f /tmp/etna.dump: Specifies the path to the dump file that you want to restore from.

### Verify the Restoration in pgAdmin 4
* Once the restoration process completes, go back to pgAdmin 4.

* Right-click on the etna database and select Refresh.

* Expand the database, and you should now see all the tables and data that were in the etna.dump file.

### Verify Data in pgAdmin 4
* You can now check the tables and run SQL queries to verify that the data has been restored successfully:

  ``` bash
  SELECT * FROM your_table_name;
  ```

* This should show you the data restored into the etna database.


 




