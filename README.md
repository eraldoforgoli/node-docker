### Dockerizing a node.js app
Before applying the following steps, make sure you have docker installed in you computer/server.

#### Step 1: Clone repo
``` git clone https://github.com/eraldoforgoli/node-docker-test.git ```

#### Step 2: Build an image of the Dockerfile located in the root of this repo
```docker build -t node-docker-test . ```  

*the . in the end of the command above represents the path of the Dockerfile, currently . because i am running the docker 
command in the location of git repository*  

#### Step 3: Run an instance of this image
``` docker run -d -p 8085:8000 node-docker-test```  

*-d stands for detached mode  
-p stand for port binding, bind the 8085 port in your local machine/server to port 8000 that docker exposes.* 

If you open localhost:8085 in your browser, you should see the app running.

### Using Services to enable load-balancing  

A docker-compose.yml file is a YAML file that defines how Docker containers should behave in production.
```
version: "3"
services:
  web:
    # replace username/repo:tag with your name and image details
    image: eraldoforgoli/node-docker-test
    deploy:
      replicas: 5
      resources:
        limits:
          cpus: "0.6"
          memory: 200M
      restart_policy:
        condition: on-failure
    ports:
      - "8083:8000"
    networks:
      - webnet
networks:
  webnet:

```
### This docker-compose.yml file tells Docker to do the following:

I have pushed my image in Docker Hub (image cloud based repository), so it can be downloaded by swarm (as specified in the file above)

```
    image: eraldoforgoli/node-docker-test
```

Run 5 instances of that image as a service called web, limiting each one to use, at most, 60% of a single core of CPU time and 200mb of memory
```
 replicas: 5
      resources:
        limits:
          cpus: "0.6"
          memory: 200M
```

Immediately restart containers if one fails.
```
      restart_policy:
        condition: on-failure
```

If you take a look at Dockerfile, you can see that i have EXPOSED port 8000, so i am mapping port 8083 to port 8000.
Instruct web’s containers to share port 8000 via a load-balanced network called webnet
```
    ports:
      - "8083:8000"
```

### Run your new load-balanced app

After adding this file in the root directory, you can run your load balanced app

#### 1. Initialize docker swarm

```
docker swarm init
```
#### 2. Run the app
```
docker stack deploy -c docker-compose.yml node-docker-test-swarm

```
#### 3. Take a look if your replicas have started
```
docker service ls
```
#### You should see something similar to this:
```
ID                  NAME                         MODE                REPLICAS            IMAGE                                   PORTS
dmy3gw1s2rgt        node-docker-test-swarm_web   replicated          5/5                 eraldoforgoli/node-docker-test:latest   *:8083->8000/tcp

```
### Check if your containers are up and running
Don't wanste time opening your browser and typing http://localhost:8083, just *curl it*
```
curl http://localhost:8083
```
You should receive a Hello World! message.
