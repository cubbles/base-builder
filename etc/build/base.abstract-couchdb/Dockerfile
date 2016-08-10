# Licensed under the Apache License, Version 2.0 (the "License"); you may not
# use this file except in compliance with the License. You may obtain a copy of
# the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
# WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
# License for the specific language governing permissions and limitations under
# the License.

FROM cubbles/base.abstract-node:0.2.0

MAINTAINER Hans-Dieter Böhlau hans-dieter.boehlau@incowia.com

# Install instructions from https://cwiki.apache.org/confluence/display/COUCHDB/Debian
ENV COUCHDB_VERSION 1.6.1

# add our user and group first to make sure their IDs get assigned consistently, regardless of other deps added later
RUN groupadd -r couchdb && useradd -d /var/lib/couchdb -g couchdb couchdb

# Install dependencies for libmozjs / spidermonkey / erlang OTP and friends
RUN apt-get update -y && apt-get install -y --no-install-recommends \
    ca-certificates libmozjs185-1.0 libicu52 libnspr4 libnspr4-0d erlang-nox \
  && rm -rf /var/lib/apt/lists/*

# Build and Install Couchdb
RUN buildDeps=' \
    gcc \
    g++ \
    erlang-dev \
    libcurl4-openssl-dev \
    libicu-dev \
    libmozjs185-dev \
    libnspr4-dev \
    make \
  ' \
  && apt-get update && apt-get install -y --no-install-recommends $buildDeps \
  && curl -sSL http://apache.openmirror.de/couchdb/source/$COUCHDB_VERSION/apache-couchdb-$COUCHDB_VERSION.tar.gz -o couchdb.tar.gz \
  && curl -sSL https://www.apache.org/dist/couchdb/source/$COUCHDB_VERSION/apache-couchdb-$COUCHDB_VERSION.tar.gz.asc -o couchdb.tar.gz.asc \
  && curl -sSL https://www.apache.org/dist/couchdb/KEYS -o KEYS \
  && gpg --import KEYS && gpg --verify couchdb.tar.gz.asc \
  && mkdir -p /usr/src/couchdb \
  && tar -xzf couchdb.tar.gz -C /usr/src/couchdb --strip-components=1 \
  && cd /usr/src/couchdb \
  && ./configure --with-js-lib=/usr/lib --with-js-include=/usr/include/mozjs \
  && make && make install \
  && apt-get purge -y --auto-remove $buildDeps \
  && rm -rf /var/lib/apt/lists/* /usr/src/couchdb /couchdb.tar.gz* /KEYS \
  && chown -R couchdb:couchdb \
      /usr/local/lib/couchdb /usr/local/etc/couchdb \
      /usr/local/var/lib/couchdb /usr/local/var/log/couchdb /usr/local/var/run/couchdb \
  && chmod -R g+rw \
     /usr/local/lib/couchdb /usr/local/etc/couchdb \
     /usr/local/var/lib/couchdb /usr/local/var/log/couchdb /usr/local/var/run/couchdb \
  && mkdir -p /var/lib/couchdb \
  && sed -e 's!/usr/local/var/log/couchdb/couch.log$!/dev/null!' -i /usr/local/etc/couchdb/default.ini

# grab gosu for easy step-down from root
RUN curl -o /usr/local/bin/gosu -SL "https://github.com/tianon/gosu/releases/download/1.7/gosu-$(dpkg --print-architecture)" \
 && chmod +x /usr/local/bin/gosu

# provide entrypoint
COPY ./docker-entrypoint.sh /entrypoint.sh

EXPOSE 5984
WORKDIR /var/lib/couchdb
ENTRYPOINT ["/entrypoint.sh"]
CMD ["couchdb"]