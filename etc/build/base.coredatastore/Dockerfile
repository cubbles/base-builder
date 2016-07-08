FROM cubbles/base.abstract-node:0.1.0

MAINTAINER Hans-Dieter Böhlau hans-dieter.boehlau@incowia.com

##############################
# couchdb
# =======
# add our user and group first to make sure their IDs get assigned consistently, regardless of other deps added later
RUN groupadd -r couchdb && useradd -d /var/lib/couchdb -g couchdb couchdb

# Install instructions from https://cwiki.apache.org/confluence/display/COUCHDB/Debian
ENV COUCHDB_VERSION 1.6.1

# download dependencies, compile and install couchdb
# considers "https://github.com/klaemo/docker-couchdb/issues/35"
RUN apt-get update -y \
  && apt-get install -y --no-install-recommends \
    build-essential ca-certificates curl \
    libmozjs185-dev libmozjs185-1.0 libnspr4 libnspr4-0d libnspr4-dev libcurl4-openssl-dev libicu-dev \
    erlang-nox erlang-dev \
  && curl -sSL http://apache.openmirror.de/couchdb/source/$COUCHDB_VERSION/apache-couchdb-$COUCHDB_VERSION.tar.gz -o couchdb.tar.gz \
  && curl -sSL https://www.apache.org/dist/couchdb/source/$COUCHDB_VERSION/apache-couchdb-$COUCHDB_VERSION.tar.gz.asc -o couchdb.tar.gz.asc \
  && curl -sSL https://www.apache.org/dist/couchdb/KEYS -o KEYS \
  && gpg --import KEYS && gpg --verify couchdb.tar.gz.asc \
  && mkdir -p /usr/src/couchdb \
  && tar -xzf couchdb.tar.gz -C /usr/src/couchdb --strip-components=1 \
  && cd /usr/src/couchdb \
  && ./configure --with-js-lib=/usr/lib --with-js-include=/usr/include/mozjs \
  && make && make install \
  && apt-get purge -y perl binutils cpp make build-essential libnspr4-dev libcurl4-openssl-dev libicu-dev \
  && apt-get autoremove -y \
  && apt-get update && apt-get install -y libicu48 --no-install-recommends \
  && rm -rf /var/lib/apt/lists/* /usr/src/couchdb /couchdb.tar.gz* /KEYS /esl.deb

# grab gosu for easy step-down from root
RUN curl -o /usr/local/bin/gosu -SL "https://github.com/tianon/gosu/releases/download/1.2/gosu-$(dpkg --print-architecture)" \
&& chmod +x /usr/local/bin/gosu

# provide the runtime config
COPY ./usr/local/etc/couchdb /usr/local/etc/couchdb
# provide initial config scripts (called from to entrypoint)
COPY ./opt/coredatastore /opt/coredatastore
RUN npm install -g grunt-cli@0.1.13
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

# permissions
RUN chown -R couchdb:couchdb \
    /usr/local/lib/couchdb /usr/local/etc/couchdb \
    /usr/local/var/lib/couchdb /usr/local/var/log/couchdb /usr/local/var/run/couchdb \
  && chmod -R g+rw \
    /usr/local/lib/couchdb /usr/local/etc/couchdb \
    /usr/local/var/lib/couchdb /usr/local/var/log/couchdb /usr/local/var/run/couchdb \
  && mkdir -p /var/lib/couchdb

#  Define mountable volumes.
VOLUME ["/usr/local/var/log/couchdb", "/usr/local/var/lib/couchdb"]

EXPOSE 5984

WORKDIR /var/lib/couchdb
ENTRYPOINT ["/entrypoint.sh"]
CMD ["couchdb"]