#!/bin/bash
set -e
echo "$0 $@"

# if command is 'TODO' ...
if [ "$1" == "TODO" ]; then
    # add datasources.local.conf
    # @see http://docs.strongloop.com/display/public/LB/datasources.json
    DATASOURCECONF=/opt/base/webpackagesearch/app/server/datasources.local.conf
    if [ -e $DATASOURCECONF ]; then {
        ln -sf $NGINXCONF /opt/webpackagesearch/app/server/datasources.local.conf
    }

    # run some setup functions
    cd /opt/webpackagesearch
    ./webpackagesearch-setup.sh
fi

# otherwise, execute the passed command
# @see https://docs.docker.com/articles/dockerfile_best-practices/
exec "$@"