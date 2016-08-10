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

FROM debian:jessie

MAINTAINER Hans-Dieter Böhlau hans-dieter.boehlau@incowia.com

##############################
# curl = used to request remote or local resources
# ca-certificates = needed to download additional modules (shipped version is to old)
# procpx = process management tools like 'ps'
# nano = simple text editor
##############################
RUN apt-get update && apt-get install -y --no-install-recommends \
		ca-certificates \
		curl \
		procps \
		nano \
	&& rm -rf /var/lib/apt/lists/*

#############################
# node js
##############################
RUN set -ex \
  && for key in \
    9554F04D7259F04124DE6B476D5A82AC7E37093B \
    94AE36675C464D64BAFA68DD7434390BDBE9B9C5 \
    0034A06D9D9B0064CE8ADF6BF1747F4AD2306D93 \
    FD3A5288F042B6850C66B31F09FE44734EB7990E \
    71DCFD284A79C3B38668286BC97EC7A07EDE3FC1 \
    DD8F2338BAE7501E3DD5AC78C273792F7D83545D \
  ; do \
# switch comment depending on the network you are in, when building the image
#    gpg --keyserver-options http-proxy=http://192.168.70.1:3128 --keyserver ha.pool.sks-keyservers.net --recv-keys "$key"; \
    gpg --keyserver ha.pool.sks-keyservers.net --recv-keys "$key"; \
  done

ENV NPM_CONFIG_LOGLEVEL info
ENV NODE_VERSION 4.2.3

RUN curl -SLO "https://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION-linux-x64.tar.gz" \
  && curl -SLO "https://nodejs.org/dist/v$NODE_VERSION/SHASUMS256.txt.asc" \
  && gpg --verify SHASUMS256.txt.asc \
  && grep " node-v$NODE_VERSION-linux-x64.tar.gz\$" SHASUMS256.txt.asc | sha256sum -c - \
  && tar -xzf "node-v$NODE_VERSION-linux-x64.tar.gz" -C /usr/local --strip-components=1 \
  && rm "node-v$NODE_VERSION-linux-x64.tar.gz" SHASUMS256.txt.asc


#############################
# node global packages
# - nodemon: https://www.npmjs.com/package/nodemon
#############################
RUN npm install -g nodemon@1.8.1 \
  && npm cache clear
