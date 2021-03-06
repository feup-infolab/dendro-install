#!/usr/bin/env bash

if [ -z ${DIR+x} ]; then
	#running by itself
	source ../constants.sh
else
	#running from dendro_full_setup_ubuntu_server_ubuntu_16.sh
	source ./constants.sh
fi

function wait_for_elasticsearch_to_boot()
{
    echo "Waiting for elasticsearch to boot up..."
    attempts=0
    max_attempts=30
    while ( nc 127.0.0.1 9200 < /dev/null ) && [[ $attempts < $max_attempts ]] ; do
        attempts=$((attempts+1))
        sleep 1;
        echo "waiting... (${attempts}/${max_attempts})"
    done
}

info "Installing ElasticSearch 6.2.2......"

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
sudo wget --progress=bar:force https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-6.2.2.deb
sudo dpkg -i elasticsearch-6.2.2.deb

#go back to initial dir
cd $setup_dir

success "Installed ElasticSearch 6.2.2."
