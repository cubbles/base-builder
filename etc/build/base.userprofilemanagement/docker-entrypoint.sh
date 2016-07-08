#!/bin/bash
set -e
echo "$0 $@"

# if command is 'nodemon' ...
if [ "$1" == "nodemon" ]; then
    # start nodemon
    cd /opt/userprofilemanagement/base-userprofilemanagement-service
    nodemon $NODEMON_OPTIONS --exec "npm start"
fi

# otherwise, execute the passed command
# @see https://docs.docker.com/articles/dockerfile_best-practices/
exec "$@"