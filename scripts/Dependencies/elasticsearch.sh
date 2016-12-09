#!/usr/bin/env bash

if [ -z ${DIR+x} ]; then 
	#running by itself
	source ../constants.sh
else 
	#running from dendro_full_setup_ubuntu_server_ubuntu_16.sh
	source ./constants.sh
fi

info "Installing ElasticSearch 2.2.3......"

#save current dir
setup_dir=$(pwd)

#install JDK 8
info "Installing Java 8 JDK"
sudo apt-get install --yes python-software-properties
sudo add-apt-repository -y ppa:webupd8team/java
sudo apt-get update -qq
sudo sh -c "echo debconf shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections"
sudo sh -c "echo debconf shared/accepted-oracle-license-v1-1 seen true | /usr/bin/debconf-set-selections"
sudo apt-get install --yes oracle-java8-installer
sudo sh -c "yes \"\" | apt-get -f install"

#install elasticsearch
cd $temp_downloads_folder
sudo wget --progress=bar:force https://download.elastic.co/elasticsearch/release/org/elasticsearch/distribution/deb/elasticsearch/2.3.3/elasticsearch-2.3.3.deb
sudo dpkg -i elasticsearch-2.3.3.deb



#go back to initial dir
cd $setup_dir

success "Installed ElasticSearch 2.2.3."
