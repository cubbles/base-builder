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
ENV NPM_VERSION 1.4.28
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

# provide initial config scripts (called from to entrypoint)
COPY ./opt/webpackagesearch /opt/webpackagesearch
RUN npm install -g strongloop@2.10.3 \
 %% npm install -g strongloop-explorer@1.7.1 \
 && npm install -g grunt-cli@0.1.13 \
 && cd /opt/webpackagesearch/app && npm install


# provide entrypoint
COPY ./docker-entrypoint.sh /entrypoint.sh

EXPOSE 3000
WORKDIR /var/lib/couchdb

ENTRYPOINT ["/entrypoint.sh"]
CMD ["slc run /opt/webpackagesearch/app"]