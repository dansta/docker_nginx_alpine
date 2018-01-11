# docker_nginx_alpine
Docker image of nginx on alpine for small static content

## Usage:

- Create a swarm on swarm routing mesh as per usual.
    docker swarm init
- On worker nodes you run the command that swarm init generates
- Create the service like this 
    docker service create --name="staticnginx" --publish published=80,target=80 --mount type=volume, \
    source=/var/lib/docker/dansta_docker_nginx_alpine/var/log, \
    destination=/var/log/ \
    --mount type=volume, \
    source=/var/lib/docker/dansta_docker_nginx_alpine/usr/share/nginx/html/, \
    destination=/usr/share/nginx/html/ \
    dansta/docker_nginx_alpine
- Scale the service to 4 containers
    docker service scale staticnginx=4
