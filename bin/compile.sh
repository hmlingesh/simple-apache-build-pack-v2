#!/usr/bin/env bash
# bin/compile <build-dir> <cache-dir>

shopt -s dotglob
set -e
# ------------------------------------------------------------------------------------------------
compile_build_dir=$1
compile_cache_dir=$2
compile_buildpack_dir=$(cd $(dirname $0) && cd .. && pwd)
compile_buildpack_bin=$compile_buildpack_dir/bin
echo "pwd: $(pwd)"
echo "compile_build_dir: $compile_build_dir"
echo "compile_cache_dir: $compile_cache_dir"
echo "compile_buildpack_bin: $compile_buildpack_bin"
echo "compile_buildpack_dir: $compile_buildpack_dir"
# ------------------------------------------------------------------------------------------------


#retrive the version from MANIFEST.INF
apache_version="$(grep 'apache' $compile_build_dir/META-INF/MANIFEST.MF | cut -d: -f2)"
echo "apache-version:"$apache_version

#if empty entry in MANIFEST then keep the default
if [ -z "$apache_version" ]; then
    apache_version="2.2.29"
    echo "Default apache-version:"$apache_version
fi

# ------------------------------------------------------------------------------------------------


# download the apache
compile_apache_tgz="$compile_buildpack_dir/vendor/httpd-2.2.29.tar.gz"
echo "apache tar has been downloaded...."
# ------------------------------------------------------------------------------------------------

cd $compile_build_dir

echo "-----> Doing work with $(basename ${compile_apache_tgz%.tar.gz}) son."

mkdir -p $compile_cache_dir/public
mv * $compile_cache_dir/public
mv $compile_cache_dir/public .


# untar
tar xzf $compile_apache_tgz
echo "tar has been extracted...."

# get inside
cd httpd-2.2.29
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

cp $compile_build_dir/index.html $HOME/apache2/htdocs

echo "project index.html has been copied over to htdocs..."

# edit the http config to listen > 1024 port since we are not an root user
sed -i "s/Listen 80/ Listen 9080/g" $HOME/apache2/conf/httpd.conf
echo "changed apache http conf listen port from 80 to 9080"

#start the apache
$HOME/apache2/bin/httpd -k start -f $HOME/apache2/conf/httpd.conf
echo "Apache has been started...."
