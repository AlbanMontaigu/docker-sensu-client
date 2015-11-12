# ================================================================================================================
# 
# Sensu server customized to act as a client and with docker options.
#
# @see https://github.com/AlbanMontaigu/docker-sensu-server
# @see https://github.com/hiroakis/docker-sensu-server
# @see https://github.com/usmanismail/docker-sensu-client
# @see http://rancher.com/comparing-monitoring-options-for-docker-deployments/
# ================================================================================================================

# Base image
FROM amontaigu/sensu-server

# Maintainer
MAINTAINER alban.montaigu@gmail.com

# Environment configuration
ENV DOCKER_BUCKET="get.docker.com" \
    DOCKER_VERSION="1.7.1" \
    DOCKER_SHA256="4d535a62882f2123fb9545a5d140a6a2ccc7bfc7a3c0ec5361d33e498e4876d5"

# System install required system components
RUN apt-get update \
    && apt-get -y install netcat curl \
    && rm -r /var/lib/apt/lists/*

# Adds docker client
# @see https://github.com/docker-library/docker/blob/6c4acc40ebc56a539fd33e7799187641dc1e27b0/1.7/Dockerfile
RUN curl -fSL "https://${DOCKER_BUCKET}/builds/Linux/x86_64/docker-$DOCKER_VERSION" -o /usr/local/bin/docker \
    && echo "${DOCKER_SHA256}  /usr/local/bin/docker" | sha256sum -c - \
    && chmod +x /usr/local/bin/docker

# Supervisor configuration
ADD ./supervisor/supervisor.conf /etc/supervisor/conf.d/supervisord.conf

# Sensu configuration
ADD ./sensu/config.json /tmp/sensu/config.json
ADD ./sensu/client.json /tmp/sensu/conf.d/client.json

# Sensu need to be root to execute docker commands
RUN sed -i -e "s%USER=sensu%USER=root%g" /etc/init.d/sensu-service

# Entrypoint setting
ADD ./docker-entrypoint.sh /docker-entrypoint.sh
ENTRYPOINT ["/docker-entrypoint.sh"]
