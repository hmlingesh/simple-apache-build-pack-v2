#!/usr/bin/env bash
# bin/release <build-dir>

BUILD_DIR=$1

#start the apache
sudo /usr/local/apache2/bin/apachectl graceful
echo "Apache has been restarted gracefully...."
