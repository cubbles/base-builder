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

function isCouchUp2Date {
    echo "Requesting database 'webpackages-store'"
    local responseCode=$(curl --write-out %{http_code} --silent --output /dev/null http://${HOST}/webpackages-store)
    echo "ResponseCode=$responseCode"
    if [ $responseCode == "200" ]; then
        return 0
    else
        return 1
    fi
}

function doUpdate {
    # 1) create database
    local db_response1="$(curl -X PUT http://${HOST}/webpackages-store)"
    # 2) create admin
    local db_response2="$(curl -X PUT http://${HOST}/_config/admins/admin -d '"admin"')"
    # return responses
    echo -e "$db_response1\n$db_response2"
}

#############
if isCouchUp ; then
    echo "CouchDB is running."
else
    echo "Error. Expected running CouchDB!"
    exit 1
fi

if isCouchUp2Date ; then
    echo "CouchDB is up2date."
    exit 0
fi

# do update
doUpdate
echo "CouchDB update finished."
