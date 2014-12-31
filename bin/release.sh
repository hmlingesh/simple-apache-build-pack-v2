#!/usr/bin/env bash
# bin/release <build-dir>

BUILD_DIR=$1

#start the apache
echo "Apache has been started.... "netstat -a | grep 9180
