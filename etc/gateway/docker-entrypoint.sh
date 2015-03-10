#!/bin/bash
set -e
echo "$0 $@"

# if command is 'nginx' (configured within the Dockerfile)
if [ "$1" == "nginx" ]; then
    # replace the /etc/nginx/nginx.conf with the one from the mounted volume
    NGINXCONF=/opt/base/gateway/nginx.conf
    NGINXCONFD=/opt/base/gateway/conf.d
    if [ -e $NGINXCONF ]; then {
        ln -sf $NGINXCONF /etc/nginx/nginx.conf
    }
    fi
    # chmod as nginx need 'other' rw permissions to htpasswd-files
    if [ -e $NGINXCONFD ]; then {
        chmod -R 775 /opt
    }
    fi
fi

# otherwise, execute the passed command
# @see https://docs.docker.com/articles/dockerfile_best-practices/
exec "$@"