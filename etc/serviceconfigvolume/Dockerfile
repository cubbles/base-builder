FROM debian:wheezy

MAINTAINER Hans-Dieter Böhlau hans-dieter.boehlau@incowia.com

# provide the config
COPY ./opt/base /opt/base

# user, group and permissions
RUN groupadd -r base && useradd -d /opt/base -g base basemanager \
&& chown -R root:base opt/base \
&& chmod -R 774 /opt/base


# Define mountable directory
VOLUME ["/opt/base"]


# provide entrypoint
COPY ./docker-entrypoint.sh /entrypoint.sh
WORKDIR /opt/base
ENTRYPOINT ["/entrypoint.sh"]
