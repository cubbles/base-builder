FROM docker.webblebase.net:444/base/abstract-node:0.3

MAINTAINER Hans-Dieter Böhlau hans-dieter.boehlau@incowia.com

# provide services
COPY ./opt/authentication/setup-resources /opt/authentication
RUN cd /opt/authentication/base-authentication-service \
 && npm install

# provide entrypoint
COPY ./docker-entrypoint.sh /entrypoint.sh

EXPOSE 3000

ENTRYPOINT ["/entrypoint.sh"]
CMD ["nodemon"]