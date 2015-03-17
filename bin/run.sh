#!/bin/sh
# purpose: manage building of base-images
# @see http://decking.io/

# make sure, the user has done a cd into the bundle (otherwise relative paths do not work)
if [ ! -e bin/check-file ]; then { echo >&2 "Please cd into the bundle before running this script."; exit 1; }
fi
echo
echo "executing: " $PWD $0 $@
echo
# "Prepare environment ..."
. bin/setenv-default.sh
. bin/setenv-local.sh
. bin/prepare_build.sh
showEnvironment

# define images
COREDATASTORE="docker.webblebase.net:444/base/coredatastore"

# "Do processing ..."
cd etc # contains decking.json
case "$1" in
	build)
		if [ ! $# -eq 3 ]; then {
			echo "Purpose: Build images"
			echo "Usage: build [image | all] [tag]"
			exit 1
		}
		else {
			IMAGE_TAG="latest"
			if [ ! -z "$3" ]; then { IMAGE_TAG=$3; }
			fi
			if [[ "$2" == "$COREDATASTORE" || "$2" == all ]]; then {
				prepare_coredatastore
			}
			fi
			# start building
			echo "building image $2:$IMAGE_TAG"
			node $NODE_MODULE_DECKING/bin/decking build $2 --tag $IMAGE_TAG
		}
		fi
		;;

	push)
		if [ ! $# -eq 4 ]; then {
			echo "Purpose: Push images into the project-docker-registry"
			echo "Usage: push [password] [image | all] [tag]"
			exit 1
		}
		else {
			echo "pushing image $3 with tag $4"
			docker login -u docker -p $2 -e hrbu@incowia.com docker.webblebase.net:444
			if [ "$3" == "all" ]; then {
				docker push "docker.webblebase.net:444/base/gateway":$4
				docker push "docker.webblebase.net:444/base/coredatastore":$4
				docker push "docker.webblebase.net:444/base/coredatastore_volume":$4
				docker push "docker.webblebase.net:444/base/serviceconfigvolume":$4
			}
			else {
				docker push $3:$4
			}
			fi
			exit 0
		}
		fi
		;;

	clean)
		echo "remove untagged images"
		docker rmi $(docker images -q --filter "dangling=true")
		exit 0
		;;


	*)
		echo "usage: $0 { build | push | clean }" >&2
		exit 1
		;;
esac