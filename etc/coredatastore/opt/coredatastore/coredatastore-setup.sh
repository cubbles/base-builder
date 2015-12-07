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

# Setup the base with basic design-docs (design-docs are services of the base)
# Note: The setup of more databases including replications from COREDB is a customization-task.
#       This can be done manually (via couchdb ui) or by script (via the couchdb api).
#
function setup {
    COREDB="webpackage-store-core"
    # 0) delayed_commits
    local response0="$(curl -X PUT http://${HOST}/_config/couchdb/delayed_commits -d '"false"')"
    # 1) create core database - ignore error, if it does already exist
    local response1="$(curl -X PUT http://${HOST}/${COREDB})"
    # 2) deploy couchapp_crc-utils; @deprecated as not longer used since modelVersion-8; upload to 'webpackage-store';
    cd /opt/coredatastore/setup-resources/couchapp_crc-utils
    local response2="$(grunt couchDeployLocal)"
    # 3) deploy couchapp_webpackage-validator
    cd /opt/coredatastore/setup-resources/couchapp_webpackage-validator
    local response3="$(grunt couchDeployLocal --db=${COREDB})"
    # 4) deploy couchapp-artifactsearch
    cd /opt/coredatastore/setup-resources/couchapp-artifactsearch
    local response4="$(grunt couchDeployLocal --db=${COREDB})"

    # lastly) create admin
    local responseSecure="$(curl -X PUT http://${HOST}/_config/admins/admin -d '"admin"')"
    # .. and return responses
    echo -e "$response0\n$response1\n$response2\n$response3\n$response4\n$responseSecure"
}

#############
if isCouchUp ; then
    echo "CouchDB is up and running."
else
    echo "Error. Expected a running CouchDB!"
    exit 1
fi

# do update
setup
echo "CouchDB setup finished."
