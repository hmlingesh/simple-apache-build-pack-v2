#!/usr/bin/env bash
# bin/compile <build-dir>
echo "Starting in Compile... "
#exec 1> >(logger -s -t $(basename $0)) 2>&1
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


# download the apache
wget http://www.webhostingjams.com/mirror/apache//httpd/httpd-$apache_version.tar.gz
echo "apache tar has been downloaded...."
# untar
tar -xf httpd-$apache_version.tar.gz
echo "tar has been extracted...."

# get inside
cd httpd-$apache_version
echo "navigating to httpd directory...."
#configure
./configure --prefix=$HOME/apache2 \
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
echo "config completed to:"$HOME/apache2
#compile the source
make 
echo "apache has been compiled successfully..."
#install 
make install
echo "apache has been installed successfully..."

# change all the file and sub folder permission for apache2
chmod 755 -R $HOME/apache2
echo "apache files are given the read permission..."

# copy project index file into htdocs location .. for testing purpose

cp $COMPLETE_DIR_PATH/index.html $HOME/apache2/htdocs

echo "project index.html has been copied over to htdocs..."

# edit the http config to listen > 1024 port since we are not an root user
sed -i "s/Listen 80/ Listen 9080/g" $HOME/apache2/conf/httpd.conf
echo "changed apache http conf listen port from 80 to 9080"
