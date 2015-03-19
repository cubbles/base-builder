#!/bin/bash

HOSTNAME=localhost
PORT=5984
HOST="${HOSTNAME}:${PORT}"

##############
function isCouchUp {
    echo "Waiting for couchdb..."
    local timeout=20
    while ! curl -X GET http://${HOST}/ >/dev/null
    do
        timeout=$(expr $timeout - 1)
        if [ $timeout -eq 0 ]; then
            # CouchDb is down (1=false)
            return 1
        fi
        sleep 1
    done
    return 0
}

function setup {
    # deploy couchapp
    cd /opt/coredatastore/setup-resources/couchapp_webpackagesearch
    local response="$(grunt couchDeployCoreDataStore)"
    # .. and return responses
    echo -e "$response"
}

#############
if isCouchUp ; then
    echo "CouchDB is running."
else
    echo "Error. Expected running CouchDB!"
    exit 1
fi

# do update
setup
echo "CouchDB setup finished."
