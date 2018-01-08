FROM gliderlabs/alpine:latest

LABEL maintainer=dansta

# Setup environment so we can build behind proxy
ARG http_proxy
ENV http_proxy ${http_proxy:-localhost:3128}
ARG https_proxy
ENV https_proxy ${https_proxy:-localhost:3128}
ARG all_proxy
ENV all_proxy ${all_proxy:-localhost:3128}

# Set env. replace right most column with values specific to your environment
ARG NGINX_USER
ENV NGINX_USER ${NGINX_USER:-nobody}
ARG NGINX_GROUP
ENV NGINX_GROUP ${NGINX_GROUP:-nobody}
ARG NGINX_WORKER_PROCESSES
ENV NGINX_WORKER_PROCESSES ${NGINX_WORKER_PROCESSES:-4}
ARG NGINX_HTTP_PORT
ENV NGINX_HTTP_PORT ${NGINX_HTTP_PORT:-80}
ARG NGINX_HTTPS_PORT
ENV NGINX_HTTPS_PORT ${NGINX_HTTPS_PORT:-443}
ARG NGINX_DOMAIN
ENV NGINX_DOMAIN ${NGINX_DOMAIN:-example.com}
ARG NGINX_WWWDOMAIN
ENV NGINX_WWWDOMAIN ${NGINX_WWWDOMAIN:-www.example.com}
ARG NGINX_SSL_PROTOCOLS
ENV NGINX_SSL_PROTOCOLS ${NGINX_SSL_PROTOCOLS:-TLSv1 TLSv1.1 TLSv1.2;}
ARG NGINX_SSL_CIPHERS
ENV NGINX_SSL_CIPHERS ${NGINX_SSL_CIPHERS:-CHACHA20:HIGH:!aNULL:!MD5:!RC4:!DES:!3DES;}

# Update cache
RUN apk update

# Install nginx
RUN apk --no-cache add nginx
RUN apk --no-cache add python3
RUN apk --no-cache add curl

# Add user, do not add home
RUN useradd ${NGINX_USER} -M -s /usr/sbin/nologin

# Add our own config file
ADD files/etc/nginx.conf /etc/nginx/nginx.conf
# Replace params
ADD replace.py /usr/local/bin/replace_conf
RUN chmod u+x /usr/local/bin/replace_conf
RUN /usr/local/bin/replace_conf /etc/nginx/nginx.conf NGINX

# Add mime.types
ADD files/etc/mime.types /etc/nginx/conf/mime.types

# Permissions
RUN chown -R ${NGINX_USER}:${NGINX_GROUP} /etc/nginx/

# Delete packages we dont need after build
RUN apk delete python3

# Document port and autoexpose
EXPOSE 80

# Check ourselves to know we are alive
HEALTHCHECK --interval=15s --timeout=3s CMD curl -x 127.0.0.1:80 || exit 1

# If we issue no docker run command
CMD ["nginx", "-g", "daemon off;"]
