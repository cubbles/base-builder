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

# etc contains the decking.json
cd etc
case "$1" in
	build)
		# check for a passed image tag
		IMAGE_TAG="latest"
		if [ ! -z "$3" ]; then { IMAGE_TAG=$3; }
		fi
		# start building
		echo "building image $2:$IMAGE_TAG" 
		node $NODE_MODULE_DECKING/bin/decking build $2 --tag $IMAGE_TAG
		;;

	push)
		# check for a passed image name
		if [ ! -z "$3" ]; then {
			echo "pushing image $3"
			docker login -u docker -p $2 -e hrbu@incowia.com docker.webblebase.net
			if [ "$3" == "all" ]; then {
				docker push "docker.webblebase.net/base/gateway":$4
				docker push "docker.webblebase.net/base/coredatastore":$4
				docker push "docker.webblebase.net/base/coredatastore_volume":$4
				docker push "docker.webblebase.net/base/serviceconfigvolume":$4
			}
			else {
				docker push $3:$4
			}
			fi
			exit 0
		}
		else {
			echo "usage: push [password] [image | all] [tag]"
			exit 1
		}
		fi
		;;

	clean)
		echo "remove untagged images"
		docker rmi $(docker images -q --filter "dangling=true")
		exit 0
		;;


	*)
		echo "usage: $0 { build [image | all] | push [password] [image | all] [tag] | clean }" >&2
		exit 1
		;;
esac