FROM debian:wheezy

MAINTAINER Hans-Dieter Böhlau hans-dieter.boehlau@incowia.com

# add our user and group first to make sure their IDs get assigned consistently, regardless of other deps added later
RUN groupadd -r couchdb && useradd -d /var/lib/couchdb -g couchdb couchdb

# folders
RUN mkdir -p /usr/local/var/lib/couchdb

# permissions
RUN chown -R couchdb:couchdb \
    /usr/local/var/lib/couchdb \
  && chmod -R g+rw \
    /usr/local/var/lib/couchdb

# Define mountable directories.
VOLUME ["/usr/local/var/lib/couchdb"]

