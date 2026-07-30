## Investigating Application Issues

When an application issue is reported, perform the following initial checks before escalating to the development team.

### 1. Verify the Running Container

Check which application container is currently serving traffic:

```bash
sudo docker ps -a
```

Confirm that either `blue-web` or `green-web` is running and has a status similar to:

```text
Up 8 hours (healthy)
```

If neither container is running or the container is marked as `unhealthy`, investigate the deployment before escalating.

---

### 2. Review Application Logs

Check the application logs for errors:

```bash
sudo docker logs <container-name>
```

Example:

```bash
sudo docker logs green-web
```

---

### 3. Check Recent Logs

If the issue has occurred recently, review logs from the last hour:

```bash
sudo docker logs --since 1h <container-name>
```

Example:

```bash
sudo docker logs --since 1h green-web
```

Look for:
- HTTP 5xx errors
- Python/Django exceptions
- Application startup failures
- Database connection errors
- Timeout errors

---

### 4. Escalate to Developers

If application errors or stack traces are found in the logs, capture the relevant log output and share it with the development team.

Include:
- Time the issue occurred
- Container name (`blue-web` or `green-web`)
- Relevant log entries
- Steps to reproduce the issue (if known)

Infrastructure engineers should not modify the application code. Once infrastructure checks have been completed and the application is confirmed to be running, any application-level errors should be escalated to the appropriate development team.

## Docker Troubleshooting and Deployment Checks

## Check Docker Containers

To check all Docker containers (running and stopped):

```bash
sudo docker ps -a
```

This command displays:
- Container ID
- Docker image
- Status
- Port mappings
- Container name

Example output:

```text
CONTAINER ID   IMAGE                                                 COMMAND                  CREATED       STATUS                 PORTS                                            NAMES
8edd08d3df0c   ghcr.io/nationalarchives/ds-catalogue:26.07.24.2495   "tna-asgi config.asg…"   8 hours ago   Up 8 hours (healthy)   8080/tcp                                        green-web
af14527d985d   traefik:v3.6                                          "/entrypoint.sh --pr…"   8 days ago    Up 8 hours             0.0.0.0:80->80/tcp, :::80->80/tcp,              traefik
                                                                                                                        0.0.0.0:8080->8080/tcp, :::8080->8080/tcp
```

## Blue-Green Deployment Check

The application uses a blue-green deployment approach.

The application containers are deployed using:

- `blue-web`
- `green-web`

To identify the active application container:

```bash
sudo docker ps -a
```

Check the container status:

- `Up` indicates the container is running.
- `healthy` indicates the application health check is passing.
- The running container (`blue-web` or `green-web`) is the active deployment serving traffic.

Example:

```text
CONTAINER ID   IMAGE                                                 STATUS                 NAMES
8edd08d3df0c   ghcr.io/nationalarchives/ds-catalogue:26.07.24.2495   Up 8 hours (healthy)   green-web
```

In this example:

- `green-web` is the active application container.
- The deployed application image is:

```text
ghcr.io/nationalarchives/ds-catalogue:26.07.24.2495
```

---

## Check Application Logs

To view logs from the active web container:

```bash
sudo docker logs <container-name>
```

Example:

```bash
sudo docker logs green-web
```

or:

```bash
sudo docker logs blue-web
```

---

## Check Logs for Last 1 Hour

To investigate recent issues, check logs generated in the last hour:

```bash
sudo docker logs --since 1h <container-name>
```

Example:

```bash
sudo docker logs --since 1h green-web
```

This helps troubleshoot:

- Application errors
- Failed requests
- Deployment issues
- Unexpected container behaviour

---

## Follow Live Container Logs

To monitor logs in real time:

```bash
sudo docker logs -f <container-name>
```

Example:

```bash
sudo docker logs -f green-web
```

Press:

```text
Ctrl + C
```

to stop following logs.

---

## Check Docker Container Health

To check the status of running containers:

```bash
sudo docker ps
```

Example:

```text
STATUS
Up 8 hours (healthy)
```

A healthy status confirms that the container health checks are passing.

---

## Check Container Resource Usage

To monitor CPU and memory usage of Docker containers:

```bash
sudo docker stats
```

This helps identify:

- High CPU usage
- High memory consumption
- Resource bottlenecks

---

## Restart Docker Container

If a container requires restarting then run our script:

```bash
startup.sh
```


---

## Traefik Reverse Proxy Check

The Etna application uses Traefik as a reverse proxy.

Check Traefik container:

```bash
sudo docker ps -a | grep traefik
```

Example:

```text
af14527d985d   traefik:v3.6   Up 8 hours   traefik
```

Traefik ports:

- Port `80` - HTTP traffic
- Port `8080` - Traefik dashboard/API

Example port mapping:

```text
0.0.0.0:80->80/tcp
0.0.0.0:8080->8080/tcp
```

---

## Useful Docker Commands

### List Running Containers

```bash
sudo docker ps
```

### List All Containers

```bash
sudo docker ps -a
```

### View Container Details

```bash
sudo docker inspect <container-name>
```

Example:

```bash
sudo docker inspect green-web
```

### View Container Logs

```bash
sudo docker logs <container-name>
```

### View Last N Lines of Logs

```bash
sudo docker logs --tail 100 <container-name>
```

Example:

```bash
sudo docker logs --tail 100 green-web
```

### Check Docker Images

```bash
sudo docker images
```

### Remove Stopped Containers

```bash
sudo docker container prune
```

### Check Docker Version

```bash
docker --version
```

## Nginx Issues

## Symptoms

- 502 Bad Gateway
- 504 Gateway Timeout
- Website not loading

## Checks
Connect to the `web-reverse-proxy` instance and 
check nginx configuration 

```bash
sudo nginx -t
```

Check nginx status

```bash
sudo systemctl status nginx
```

Restart nginx

```bash
sudo systemctl restart nginx
```

Reload configuration

```bash
sudo systemctl reload nginx
sudo nginx -s reload
```

View nginx error logs

```bash
sudo tail -100 /var/log/nginx/error.log
```

View access logs

```bash
sudo tail -100 /var/log/nginx/access.log
```
