#!/bin/sh
#If a command exits with an error and the caller does not check such error, the script aborts immediately.
set -e

# purpose: manage building of base-images
# @see http://decking.io/
CURRENT_DIR=$(pwd)
WORK_DIR=$CURRENT_DIR/etc/build
# make sure, the user has done a cd into the bundle (otherwise relative paths do not work)
if [ ! -e bin/check-file ]; then { echo >&2 "Please cd into the bundle before running this script."; exit 1; }
fi
#echo
#echo "executing: " $PWD $0 $@
echo
# "Prepare environment ..."
. bin/setenv.sh
. bin/prepare_build.sh
#showEnvironment

# define images
COREDATASTORE="base.coredatastore"
WEBPACKAGESEARCH="base.webpackagesearch"
AUTHENTICATION="base.authentication"
USERPROFILEMANAGEMENT="base.userprofilemanagement"

# "Do processing ..."
cd $WORK_DIR
case "$1" in
	builder-cli)
		if [ ! $# -eq 3 ] && [ ! $# -eq 4 ]; then {
			echo "Purpose: Build images"
			echo "Usage: builder-cli build <image> [tag]"
			exit 1
		}
		else {
			# image param
			if [[ "$3" == "$COREDATASTORE" ]]; then {
				prepare_coredatastore
			}
			fi
			if [[ "$3" == "$WEBPACKAGESEARCH" ]]; then {
				prepare_webpackagesearch $WORK_DIR
			}
			fi
			if [[ "$3" == "$AUTHENTICATION" ]]; then {
				prepare_authentication
			}
			fi
			if [[ "$3" == "$USERPROFILEMANAGEMENT" ]]; then {
				prepare_userprofilemanagement
			}
			fi

			# start building
			echo "building image $3:$4"
			cd $WORK_DIR
			sudo node $BUILDER_CLI_DIR/builder-cli $@ --tag $4
		}
		fi
		;;

	push)
		if [ ! $# -eq 3 ]; then {
			echo "Purpose: Push images into the docker registry"
			echo "Usage: push <image> <tag>"
			exit 1
		}
		else {
			echo "Pushing image $2 with tag $3"
			# login
			# > https://docs.docker.com/engine/reference/commandline/login/
            # for the old registry at 'docker.webblebase.net:444' use 'docker' as username
            echo -n " * Username: "; read user
            echo -n " * Password: "; read -s password
			docker login -u $user -p $password

			# push
			docker push $2:$3
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
		echo "usage: $0 { builder-cli | push | clean }" >&2
		echo
		exit 1
		;;
esac