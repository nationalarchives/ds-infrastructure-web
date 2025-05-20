## What is Redis?
Redis is an open-source, in-memory data structure store used as a database, cache, and message broker.

* Created a Launch Template named `platform-redis `which includes a user data script that installs and starts Redis.

* The instance is tagged with the name `platform-redis`.

* Then launch an EC2 instance using this Launch Template.

* The instance will automatically install and start the Redis server on boot.

## Connecting to platform-redis via Session Manager & Installing Redis from Source

## Connect to EC2 Instance via Session Manager

1. Go to the **AWS Console**.
2. Navigate to **EC2 > Instances**.
3. Locate the instance named `platform-redis`.
4. Select the instance and click on **Connect**.
5. Choose the **Session Manager** tab.
6. Click on **Connect**.

> Ensure the instance is using an IAM role with `AmazonSSMManagedInstanceCore` policy attached, and that SSM Agent is installed and running.

---

## Install Development Tools

Once you are connected to the instance via Session Manager, run the following commands:

### Install Development Tools Group

```bash
sudo yum groupinstall "Development Tools" -y

sudo yum install gcc make -y
```

### Download and Build Redis from Source
### Download Redis Source Code (v7.0.12)
```bash
sudo curl -O http://download.redis.io/releases/redis-7.0.12.tar.gz
```
### Extract the tarball
```bash
sudo tar xzf redis-7.0.12.tar.gz
cd redis-7.0.12
```
### Compile Redis

```bash
sudo make redis-cli
sudo cp /usr/bin/redis-7.0.12/src/redis-cli /usr/local/bin
```

## Running Redis (Latest) Using Docker Compose

### Navigate to the Docker Directory

```bash
cd /var/docker
```
### Create or Edit the compose.yml File
* Create a file named compose.yml with the following content:
```bash
services:
  redis:
    image: redis/redis-stack-server:latest
    ports:
      - 6379:6379
    restart: unless-stopped
    healthcheck:
      test: ["CMD", "redis-cli", "--raw", "incr", "ping"]
    volumes:
      - redis_data:/data
volumes:
  redis_data:
  ```

  This configuration:

* Pulls the latest Redis image from Docker Hub

* Names the container redis-stack-server

* Maps port 6379 from the container to the host

* Restarts the container automatically unless manually stopped

### Run Docker Compose
Run the following command to start the Redis container:

```bash
sudo docker-compose up -d
```
### Verify the Redis Container
Check if the Redis container is running:

```bash
sudo docker ps -a
```

You should see a container named redis-stack-server running and listening on port 6379.

### Test the redis connection

```bash
redis-cli -h platform-redis.${env}.local -p 6379 PING
```
It should return PONG









