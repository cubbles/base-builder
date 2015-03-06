#!/bin/bash
set -e
echo "$0 $@"

# if command is 'nginx' (configured within the Dockerfile)
if [ "$1" == "nginx" ]; then
    # replace the /etc/nginx/nginx.conf with the one from the mounted volume
    NGINXCONF=/opt/base/gateway/nginx.conf
    if [ -e $NGINXCONF ]; then {
        ln -sf $NGINXCONF /etc/nginx/nginx.conf
    }
    fi
    # replace the /etc/nginx/conf.d folder ...
    NGINXCONFD=/opt/base/gateway/conf-base.d
    if [ -e $NGINXCONFD ]; then {
        ln -sf $NGINXCONFD /etc/nginx/conf-base.d
    }
    fi
fi

# otherwise, execute the passed command
# @see https://docs.docker.com/articles/dockerfile_best-practices/
exec "$@"