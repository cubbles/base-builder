FROM cubbles/base.abstract-node:0.1.0

MAINTAINER Hans-Dieter Böhlau hans-dieter.boehlau@incowia.com

# provide services
COPY ./opt/userprofilemanagement/setup-resources /opt/userprofilemanagement
RUN cd /opt/userprofilemanagement/base-userprofilemanagement-service \
 && npm install

# provide entrypoint
COPY ./docker-entrypoint.sh /entrypoint.sh

EXPOSE 3000

ENTRYPOINT ["/entrypoint.sh"]
CMD ["nodemon"]