#!/bin/sh
# Note: Use this file to override/extend the default settings
export PATH=/mnt/sda1/base_utils/node/bin:$PATH

# Overrides setenv-default/showEnvironment()
showEnvironment(){
	echo "PATH=$PATH"
}