#!/bin/bash
set -e
echo "$0 $@"

# if command is 'slc' ...
if [ "$1" == "slc" ]; then {
    # add datasources.local.conf
    # @see http://docs.strongloop.com/display/public/LB/datasources.json
    DATASOURCECONF=/opt/base/webpackagesearch/app/server/datasources.local.json
    if [ -e $DATASOURCECONF ]; then {
        ln -sf $NGINXCONF /opt/webpackagesearch/app/server/datasources.local.json
    }
    fi

    # run some setup functions
    cd /opt/webpackagesearch
    ./webpackagesearch-setup.sh
}
fi

# otherwise, execute the passed command
# @see https://docs.docker.com/articles/dockerfile_best-practices/
exec "$@"