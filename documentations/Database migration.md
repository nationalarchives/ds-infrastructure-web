## **Steps to Log In to Platform.sh via Terminal**:

1. **Open Terminal**:

* Open the terminal on your local machine to start the login process.

2. **Run the `platform login` Command**:

* To log in, use the following command:

    `platform login`

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

   `platform db:dump
`

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

     ` ls `

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

  * **Maintenance database**: Enter the name of the database you want to connect to (e.g., postgres)

  * **Username**: Provide the PostgreSQL username (Get the details from secret manager).

  * **Password**: Enter the password for the PostgreSQL user.

4.**Save and Connect**:

* After filling out the connection details, click Save.

* You should now see your server listed under Servers in pgAdmin.

5. **Test the Connection**:

* Once the server is added, you can expand the connection, navigate through databases, and start querying your PostgreSQL instance.

