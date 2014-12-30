#!/usr/bin/env bash
# bin/release <build-dir>

BUILD_DIR=$1

#start the apache
$HOME/apache2/bin/httpd -k start  -f $HOME/apache2/conf/httpd.conf
echo "Apache has been started...."
