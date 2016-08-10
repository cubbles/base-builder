#!/bin/bash
set -e
echo "$0 $@"

# if command is 'couchdb' ...
if [ "$1" == "couchdb" ]; then
    # exec couchdb as user 'couchdb'
    # note: exec will REPLACE the current shell, the following commands in this script will NOT be executed
    HOME=/var/lib/couchdb exec gosu couchdb "$@"
fi

# otherwise, execute the passed command
# @see https://docs.docker.com/articles/dockerfile_best-practices/
exec "$@"