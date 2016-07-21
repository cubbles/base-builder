FROM cubbles/base.abstract-node:0.1.0

MAINTAINER Hans-Dieter Böhlau hans-dieter.boehlau@incowia.com

# provide services
COPY ./opt/testsuite /opt/testsuite
RUN cd /opt/testsuite \
 && npm install

# provide entrypoint
COPY ./docker-entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]