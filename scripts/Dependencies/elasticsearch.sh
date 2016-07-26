#!/usr/bin/env bash

echo "[INFO] ElasticSearch 2.2.3......"

if [ -z ${DIR+x} ]; then 
	#running by itself
	source ../constants.sh
else 
	#running from dendro_full_setup_ubuntu_server_ubuntu_16.sh
	source ./constants.sh
fi

#save current dir
setup_dir=$(pwd)

#install elasticsearch
sudo add-apt-repository ppa:webupd8team/java
sudo apt-get -qq update
sudo apt-get -qq install oracle-java8-installer
cd $temp_downloads_folder
sudo wget --progress=bar:force https://download.elastic.co/elasticsearch/release/org/elasticsearch/distribution/deb/elasticsearch/2.3.3/elasticsearch-2.3.3.deb
sudo dpkg -i elasticsearch-2.3.3.deb

#go back to initial dir
cd $setup_dir

echo "[OK] Installed ElasticSearch 2.2.3."
