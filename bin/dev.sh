#!/bin/sh
# purpose: support image development
# usage: run it with a cluster-name as argument

# make sure, the user has done a cd into the bundle (otherwise relative paths do not work)
if [ ! -e bin/check-file ]; then { echo >&2 "Please cd into the bundle before running this script."; exit 1; }
fi

### begin - functions
### note: this is an sh-Script - not a bash-Script, as it needs to be run on boot2docker
### http://www.tutorialspoint.com/unix/unix-shell-functions.htm
replaceCluster ()
{
    echo "start cluster replacement"
    cd ../base
    ./bin/run.sh stop $1
    ./bin/run.sh create $1
    ./bin/run.sh start $1
    sleep 5
    docker logs base.$1
}

### end - functions

if [ "$1" == "coredatastore" ]; then
    if [ ! $2 == "reuseimage" ]; then
        ./bin/run.sh build docker.webblebase.net/base/$1 1.0-SNAPSHOT
    fi
    replaceCluster $1
    exit 0
fi


