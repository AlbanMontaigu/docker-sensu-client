# ================================================================================================================
# Sensu server customized to act as a client and with docker options.
#
# @see https://github.com/hiroakis/docker-sensu-server
# @see https://github.com/usmanismail/docker-sensu-client
# @see http://rancher.com/comparing-monitoring-options-for-docker-deployments/
# ================================================================================================================

# Base image (base = centos)
FROM hiroakis/docker-sensu-server

# Maintainer
MAINTAINER alban.montaigu@gmail.com

# Environment configuration
ENV DOCKER_BUCKET="get.docker.com" \
    DOCKER_VERSION="1.7.1" \
    DOCKER_SHA256="4d535a62882f2123fb9545a5d140a6a2ccc7bfc7a3c0ec5361d33e498e4876d5"

# System install required system components
RUN yum -y install nc

# Adds docker client
# @see https://github.com/docker-library/docker/blob/6c4acc40ebc56a539fd33e7799187641dc1e27b0/1.7/Dockerfile
RUN curl -fSL "https://${DOCKER_BUCKET}/builds/Linux/x86_64/docker-$DOCKER_VERSION" -o /usr/local/bin/docker \
    && echo "${DOCKER_SHA256}  /usr/local/bin/docker" | sha256sum -c - \
    && chmod +x /usr/local/bin/docker

# Supervisor configuration
ADD ./supervisor/supervisor.conf /etc/supervisord.conf

# Sensu configuration
ADD ./sensu/config.json /tmp/sensu/config.json
ADD ./sensu/client.json /tmp/sensu/conf.d/client.json

# Entrypoint setting
ADD ./docker-entrypoint.sh /docker-entrypoint.sh
ENTRYPOINT ["/docker-entrypoint.sh"]
