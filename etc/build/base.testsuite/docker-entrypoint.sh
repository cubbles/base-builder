#!/bin/bash
set -e
echo "$0 $@"

# execute the passed command
# @see https://docs.docker.com/articles/dockerfile_best-practices/
cd "/opt/testsuite"
exec node test-cli.js "$@"