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
    # 0) delayed_commits
    local response0="$(curl -X PUT http://${HOST}/_config/couchdb/delayed_commits -d '"false"')"
    # 1) create database
    local response1="$(curl -X PUT http://${HOST}/webpackage-store)"
    # 2) deploy couchapp_crc-utils
    cd /opt/coredatastore/setup-resources/couchapp_crc-utils
    local response2="$(grunt couchDeployLocal)"

    # lastly) create admin
    local responseSecure="$(curl -X PUT http://${HOST}/_config/admins/admin -d '"admin"')"
    # .. and return responses
    echo -e "$response0\nresponse1\n$response2\n$responseSecure"
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
