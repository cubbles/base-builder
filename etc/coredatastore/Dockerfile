FROM debian:wheezy

MAINTAINER Hans-Dieter Böhlau hans-dieter.boehlau@incowia.com

#############################
# node js
# =======
# verify gpg and sha256: http://nodejs.org/dist/v0.10.30/SHASUMS256.txt.asc
# gpg: aka "Timothy J Fontaine (Work) <tj.fontaine@joyent.com>"
# gpg: aka "Julien Gilli <jgilli@fastmail.fm>"
RUN gpg --keyserver pool.sks-keyservers.net --recv-keys 7937DFD2AB06298B2293C3187D33FF9D0246406D 114F43EE0176B71C7BC219DD50A3051F888C628D
ENV NODE_VERSION 0.12.0
ENV NPM_VERSION 2.7.1
RUN buildDeps='curl' \
  && set -x \
  && apt-get update && apt-get install -y $buildDeps --no-install-recommends \
  && rm -rf /var/lib/apt/lists/* \
  && curl -SLO "http://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION-linux-x64.tar.gz" \
  && curl -SLO "http://nodejs.org/dist/v$NODE_VERSION/SHASUMS256.txt.asc" \
  && gpg --verify SHASUMS256.txt.asc \
  && grep " node-v$NODE_VERSION-linux-x64.tar.gz\$" SHASUMS256.txt.asc | sha256sum -c - \
  && tar -xzf "node-v$NODE_VERSION-linux-x64.tar.gz" -C /usr/local --strip-components=1 \
  && rm "node-v$NODE_VERSION-linux-x64.tar.gz" SHASUMS256.txt.asc \
  && apt-get purge -y --auto-remove $buildDeps \
  && npm install -g npm@"$NPM_VERSION" \
  && npm cache clear

##############################
# couchdb
# =======
# add our user and group first to make sure their IDs get assigned consistently, regardless of other deps added later
RUN groupadd -r couchdb && useradd -d /var/lib/couchdb -g couchdb couchdb

# Install instructions from https://cwiki.apache.org/confluence/display/COUCHDB/Debian
ENV COUCHDB_VERSION 1.6.1

# download dependencies, compile and install couchdb
RUN apt-get update -y \
  && apt-get install -y --no-install-recommends \
    build-essential ca-certificates curl \
    libmozjs185-dev libmozjs185-1.0 libnspr4 libnspr4-0d libnspr4-dev libcurl4-openssl-dev libicu-dev \
  && curl -ssL https://packages.erlang-solutions.com/erlang-solutions_1.0_all.deb -o esl.deb && dpkg -i esl.deb && apt-get update \
  && apt-get install -y --no-install-recommends erlang-nox=1:17.4 erlang-dev=1:17.4 \
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
RUN cd /opt/coredatastore/setup-resources/couchapp_crc-utils \
 && npm install -g grunt-cli \
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

# Define mountable directories.
VOLUME ["/usr/local/var/log/couchdb", "/usr/local/var/lib/couchdb"]

EXPOSE 5984
WORKDIR /var/lib/couchdb

ENTRYPOINT ["/entrypoint.sh"]
CMD ["couchdb"]