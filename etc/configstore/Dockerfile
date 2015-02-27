FROM debian:wheezy

MAINTAINER Hans-Dieter Böhlau hans-dieter.boehlau@incowia.com


# provide the config
COPY ./opt/base /opt/base

# user, group and permissions
RUN groupadd -r base && useradd -d /opt/base -g base basemanager
RUN chown -R basemanager:base opt/base
RUN chmod -R g+rw /opt/base

# Define mountable directories.
VOLUME ["/opt/base"]


# provide entrypoint
COPY ./docker-entrypoint.sh /entrypoint.sh
WORKDIR /opt/base
ENTRYPOINT ["/entrypoint.sh"]
