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
    # chmod as nginx needs 'other' rw permissions to htpasswd-files
    if [ -e $NGINXCONFD ]; then {
        chmod -R 775 /opt
    }
    fi

    # base.ssl:
    # replace ssl_certificate directive
    SSL_CONFIG_FILE="/opt/base/gateway/conf.d/base.ssl"
    OLD_CERT_DECLARATION=".*ssl_certificate .*"
    NEW_CERT_DECLARATION="#ssl_certificate ... commented out by dockers entrypoint script"
    # if value set within the environment (set by docker)
    if [ ! -z "$SSL_CERT" ]; then { NEW_CERT_DECLARATION="ssl_certificate $SSL_CERT ;"; }; fi
    echo $NEW_CERT_DECLARATION
    sed -i -- "s/$OLD_CERT_DECLARATION/${NEW_CERT_DECLARATION//\//\\/}/" $SSL_CONFIG_FILE # note: NEW will be escaped using bash find and replace
    # replace ssl_certificate_key directive
    OLD_CERTKEY_DECLARATION=".*ssl_certificate_key .*"
    NEW_CERTKEY_DECLARATION="#ssl_certificate_key ... commented out by dockers entrypoint script"
    # if value set within the environment (set by docker)
    if [ ! -z "$SSL_CERT_KEY" ]; then { NEW_CERTKEY_DECLARATION="ssl_certificate_key $SSL_CERT_KEY ;"; }; fi
    echo $NEW_CERTKEY_DECLARATION
    sed -i -- "s/$OLD_CERTKEY_DECLARATION/${NEW_CERTKEY_DECLARATION//\//\\/}/" $SSL_CONFIG_FILE # note: NEW will be escaped using bash find and replace

    # webblebase.net.ssl (remove this config, as soon as webblebase.net is outdated)
    # replace ssl_certificate directive
    SSL_CONFIG_FILE="/opt/base/gateway/conf.d/webblebase.net.ssl"
    OLD_CERT_DECLARATION=".*ssl_certificate .*"
    NEW_CERT_DECLARATION="#ssl_certificate ... commented out by dockers entrypoint script"
    # if value set within the environment (set by docker)
    if [ ! -z "$SSL_CERT_WEBBLEBASENET" ]; then { NEW_CERT_DECLARATION="ssl_certificate $SSL_CERT_WEBBLEBASENET ;"; }; fi
    echo $NEW_CERT_DECLARATION
    sed -i -- "s/$OLD_CERT_DECLARATION/${NEW_CERT_DECLARATION//\//\\/}/" $SSL_CONFIG_FILE # note: NEW will be escaped using bash find and replace
    # replace ssl_certificate_key directive
    OLD_CERTKEY_DECLARATION=".*ssl_certificate_key .*"
    NEW_CERTKEY_DECLARATION="#ssl_certificate_key ... commented out by dockers entrypoint script"
    # if value set within the environment (set by docker)
    if [ ! -z "$SSL_CERT_KEY_WEBBLEBASENET" ]; then { NEW_CERTKEY_DECLARATION="ssl_certificate_key $SSL_CERT_KEY_WEBBLEBASENET ;"; }; fi
    echo $NEW_CERTKEY_DECLARATION
    sed -i -- "s/$OLD_CERTKEY_DECLARATION/${NEW_CERTKEY_DECLARATION//\//\\/}/" $SSL_CONFIG_FILE # note: NEW will be escaped using bash find and replace


    # start nginx
    echo -e "Starting nginx..."
    # exec /usr/local/nginx/sbin/nginx -g "daemon off;"
    cd /opt/base/gateway
    nodemon $NODEMON_OPTIONS --exec "/usr/local/nginx/sbin/nginx"
fi

# otherwise, execute the passed command
# @see https://docs.docker.com/articles/dockerfile_best-practices/
exec "$@"