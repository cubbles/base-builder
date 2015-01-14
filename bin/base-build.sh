#!/bin/sh
# @see http://decking.io/

# make sure, the user has done a cd into the bundle (otherwise relative paths do not work)
[[ -e bin/check-file ]] || { echo >&2 "Please cd into the bundle before running this script."; exit 1; }

echo 
echo "Prepare environment ..."
echo "======================"
source bin/setenv-default.sh
source bin/setenv-local.sh
showEnvironment

echo
echo "Do processing ..."
echo "================="
cd etc
case "$1" in
	build)
		echo "build an image or pass 'all' to build all"
		sudo decking build $2
		;;

	status)
		echo "check the status of a cluster's containers"
		decking status $2
		;;


	*)
		echo "usage: $0 { build [image | all] | status [cluster] }" >&2
		exit 1
		;;
esac