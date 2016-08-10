FROM cubbles/base.abstract-couchdb:0.2.0

MAINTAINER Hans-Dieter Böhlau hans-dieter.boehlau@incowia.com

# we need grunt-cli as the couchapp-deployments are based on grunt
RUN npm install -g grunt-cli@0.1.13

# provide the runtime config
COPY ./usr/local/etc/couchdb /usr/local/etc/couchdb
RUN chown -R couchdb:couchdb /usr/local/etc/couchdb

# provide initial config scripts (called from to entrypoint)
COPY ./opt/coredatastore /opt/coredatastore
RUN cd /opt/coredatastore/setup-resources/couchapp_crc-utils \
 && npm install
RUN cd /opt/coredatastore/setup-resources/base-couchapps_authentication-utils \
 && npm install
RUN cd /opt/coredatastore/setup-resources/base-couchapp_webpackage-validator \
 && npm install
RUN cd /opt/coredatastore/setup-resources/base-couchapp-artifactsearch \
 && npm install

# provide entrypoint
COPY ./docker-entrypoint.sh /entrypoint.sh

#  Define mountable volumes.
VOLUME ["/usr/local/var/log/couchdb", "/usr/local/var/lib/couchdb"]

EXPOSE 5984
WORKDIR /var/lib/couchdb
ENTRYPOINT ["/entrypoint.sh"]
CMD ["couchdb"]