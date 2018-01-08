FROM gliderlabs/alpine:latest

# Setup environment so we can build behind proxy
ARG http_proxy
ENV http_proxy ${http_proxy:-localhost:3128}
ARG https_proxy
ENV https_proxy ${https_proxy:-localhost:3128}
ARG all_proxy
ENV all_proxy ${all_proxy:-localhost:3128}

# Update cache
RUN apk update

# Install nginx
RUN apk --no-cache add nginx

# Document port and autoexpose
EXPOSE 80

# If we issue no docker run command
CMD ["nginx", "-g", "daemon off;"]

# 
ENTRYPOINT ["nginx", "-g", "daemon off;"]
