#!/bin/sh
# purpose: manage building of base-images
# @see http://decking.io/

# make sure, the user has done a cd into the bundle (otherwise relative paths do not work)
if [ ! -e bin/check-file ]; then { echo >&2 "Please cd into the bundle before running this script."; exit 1; }
fi

echo 
echo "Prepare environment ..."
echo "======================"
. bin/setenv-default.sh
. bin/setenv-local.sh
showEnvironment

echo
echo "Do processing ..."
echo "================="
cd etc
case "$1" in
	build)
		echo "building image(s) ... $2" 
		#ERROUT=$(node $NODE_MODULE_DECKING/bin/decking build >$2)
		node $NODE_MODULE_DECKING/bin/decking build $2
		echo $ERROUT
		case "$ERROUT" in 
		   *"EACCES"* ) echo >&2 "Permission problem. Try to run the script as sudo!"
		   exit 1;;
		esac
		;;

	status)
		echo "check the status of a cluster's containers"
		node $NODE_MODULE_DECKING/bin/decking status $2
		;;


	*)
		echo "usage: $0 { build [image | all] | status [cluster] }" >&2
		exit 1
		;;
esac