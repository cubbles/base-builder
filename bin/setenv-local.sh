#!/bin/sh
# Note: Use this file to override/extend the default settings



# Overrides setenv-default/showEnvironment()
showEnvironment(){
	echo "PATH=$PATH"
	echo "node version = $(node -v)"
}