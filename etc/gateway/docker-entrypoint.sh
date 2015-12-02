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

    # base.ssl: replace ssl_certificate directive
    OLD=".*ssl_certificate .*"
    NEW="#ssl_certificate ... commented out by dockers entrypoint script"
    # if value set within the environment (set by docker)
    if [ ! -z "$SSL_CERTIFICATE" ]; then { NEW="ssl_certificate $SSL_CERTIFICATE ;"; }; fi
    echo $NEW
    sed -i -- "s/$OLD/${NEW//\//\\/}/" /opt/base/gateway/conf.d/base.ssl # note: NEW will be escaped using bash find and replace

    # base.ssl: replace ssl_certificate_key directive
    OLD=".*ssl_certificate_key .*"
    NEW="#ssl_certificate_key ... commented out by dockers entrypoint script"
    # if value set within the environment (set by docker)
    if [ ! -z "$SSL_CERTIFICATE_KEY" ]; then { NEW="ssl_certificate_key $SSL_CERTIFICATE_KEY ;"; }; fi
    echo $NEW
    sed -i -- "s/$OLD/${NEW//\//\\/}/" /opt/base/gateway/conf.d/base.ssl # note: NEW will be escaped using bash find and replace

    # start nginx
    echo -e "Starting nginx..."
    exec /usr/local/nginx/sbin/nginx -g "daemon off;"
fi

# otherwise, execute the passed command
# @see https://docs.docker.com/articles/dockerfile_best-practices/
exec "$@"