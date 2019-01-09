# Docker Notes

### **Ubuntu docker install bootstrap**

`sudo wget -qO- https://get.docker.com | sh`

---
### Create docker group to allow members of the group to not require sudo prefix adds $user
`sudo groupadd docker`

`sudo usermod -aG docker $user`

### Docker default ports
- docker engine port 2375

- secure engine port 2376

- swarm port 2377

---
### **Docker Commands**
---

`docker version`

    shows current docker version
`docker info`

    shows detailed info about the installed docker engine
`docker ps`

    lists running containers
`docker ps -a`

    lists containers that have previously ran but are now exited
`docker images`

    shows images that are stored locally
`docker run -d ubuntu:latest`

    runs latest ubuntu image in detached mode (does not auto connect to container terminal)
`docker pull`

    copies images to the docker host
`docker rmi`

    removes images from the docker host
`docker stop`

    stops running containers
`docker rm`

    removes (deletes) stopped containers
