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
    ACLDB="acls"
    GROUPSDB="groups"
    # 0) delayed_commits
    local response0="$(curl -X PUT http://${HOST}/_config/couchdb/delayed_commits -d '"false"')"

    # 1) create databases
    # 1.1) create core database - ignore error, if it does already exist
    echo "create core database"
    local response1_1="$(curl -X PUT http://${HOST}/${COREDB})"
    echo $response1_1
    # 1.2) create groups database - ignore error, if it does already exist
    echo "create groups database"
    local response1_2="$(curl -X PUT http://${HOST}/${GROUPSDB})"
    echo $response1_2
    # 1.3) create acls database - ignore error, if it does already exist
    echo "create acls database"
    local response1_3="$(curl -X PUT http://${HOST}/${ACLDB})"
    echo $response1_3

    # 2) deploy couchapp_crc-utils; @deprecated as not longer used since modelVersion-8; upload to 'webpackage-store';
    echo "deploy couchapp_crc-utils"
    cd /opt/coredatastore/setup-resources/couchapp_crc-utils
    local response2="$(grunt couchDeployLocal)"
    echo $response2

    # 3) deploy couchapp_users-authentication-utils
    echo "deploy base-couchapps_authentication-utils"
    cd /opt/coredatastore/setup-resources/base-couchapps_authentication-utils
    local response3="$(grunt couchDeployLocal)"
    echo $response3

    # 4) deploy couchapp_webpackage-validator
    echo "deploy couchapp_webpackage-validator"
    cd /opt/coredatastore/setup-resources/couchapp_webpackage-validator
    local response4="$(grunt couchDeployLocal --db=${COREDB})"
    echo $response4

    # 5) deploy couchapp-artifactsearch
    echo "deploy couchapp-artifactsearch"
    cd /opt/coredatastore/setup-resources/couchapp-artifactsearch
    local response5="$(grunt couchDeployLocal --db=${COREDB})"
    echo $response5

    # auth) enable proxy authentication to allow the authentication handled by the gateway
    echo "config auth handlers"
    local responseAuth="$(curl -H 'Content-Type: application/json' -X PUT http://${HOST}/_config/httpd/authentication_handlers -d '\"{couch_httpd_auth, cookie_authentication_handler}, {couch_httpd_auth, proxy_authentication_handler}, {couch_httpd_auth, default_authentication_handler}\"')"
    echo $responseAuth

    # lastly) create admin
    echo "setting admin account"
    local responseSecure="$(curl -X PUT http://${HOST}/_config/admins/admin -d '"admin"')"
    echo $responseSecure
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
