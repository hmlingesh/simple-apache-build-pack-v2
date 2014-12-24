#!/usr/bin/env bash
# bin/compile <build-dir>

#directory structure
echo "present working directory:"$(pwd)
echo "ARG0:"$1
COMPLETE_DIR_PATH=$(pwd)/$1
echo "COMPLETE_PATH:"$COMPLETE_DIR_PATH

#retrive the version from MANIFEST.INF

apache_version="$(grep 'apache' $COMPLETE_PATH/META-INF/MANIFEST.MF | cut -d: -f2)"

echo "apache-version:"$apache_version

#if empty entry in MANIFEST then keep the default
if [ -z "$apache_version" ]; then
    apache_version="2.2.29"
    echo "Default apache-version:"$apache_version
fi



# getting dependency of apache2
sudo apt-get build-dep apache2

# download the apache
sudo wget http://www.webhostingjams.com/mirror/apache//httpd/httpd-$apache_version.tar.gz

# untar
tar -xf httpd-$apache_version.tar.gz

#login as Root
su
source /etc/profile

# get inside
cd httpd-{$apache_version}

#configure
./configure --prefix=/usr/local/apache2 \
--enable-mods-shared=all \
--enable-http \
--enable-deflate \
--enable-expires \
--enable-slotmem-shm \
--enable-headers \
--enable-rewrite \
--enable-proxy \
--enable-proxy-balancer \
--enable-proxy-http \
--enable-proxy-fcgi \
--enable-mime-magic \
--enable-log-debug \
--with-mpm=event

#compile the source
make 

#install 
sudo make install

# copy project index file into htdocs location

sudo cp $COMPLETE_DIR_PATH/index.html /usr/local/apache2/htdocs



