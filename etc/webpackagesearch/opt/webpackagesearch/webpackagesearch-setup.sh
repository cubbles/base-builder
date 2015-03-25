#!/bin/bash

HOSTNAME=coredatastore
PORT=5984
COUCH_URL="http://${HOSTNAME}:${PORT}"
DATABASE_URL="${COUCH_URL}/webpackage-store"

##############
function isCouchUp {
    echo "Waiting for couchdb and database to be available ..."
    curl_couch="curl -X GET ${COUCH_URL} --output /dev/null"
    curl_database="curl -X GET --write-out %{http_code} --output /dev/null ${DATABASE_URL}"
    local timeout=20
    while ( ! $(${curl_couch}) ) || [ 404 == $(${curl_database}) ]
    do
        timeout=$(expr $timeout - 1)
        if [ $timeout -eq 0 ]; then
            # couch or database not available (1==false)
            return 1
        fi
        sleep 1
    done
    return 0
}

function setup {
    # deploy couchapp
    # note: this is a manually defined design-doc
    # ... for background-knowledge @see https://www.npmjs.com/package/loopback-connector-couch
    cd /opt/webpackagesearch/setup-resources/couchapp-webpackagesearch
    grunt_couchDeployCoreDataStore="grunt couchDeployCoreDataStore"
    local attempts=20
    local timeout=$attempts
    local grunt_couchDeployCoreDataStoreResponse=""
    until [[ $grunt_couchDeployCoreDataStoreResponse == *"Done, without errors."* ]]
    do
        timeout=$(expr $timeout - 1)
        if [ $timeout -eq 0 ]; then
            # deployment failed (1==false)
            return 1
        fi
        sleep 1
        echo "... attempt $(expr $attempts - $timeout) of $attempts"
        grunt_couchDeployCoreDataStoreResponse=$(${grunt_couchDeployCoreDataStore})
        echo "$grunt_couchDeployCoreDataStoreResponse"
    done
    return 0
}

#############
echo "CouchDB setup ..."
if isCouchUp ; then
    echo "CouchDB and Database are available."
else
    echo "Error. Expected CouchDB and Database to be available!"
    exit 1
fi

# do update
setup
echo "CouchDB setup finished."
