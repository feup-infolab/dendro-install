#!/usr/bin/env bash

echo "[INFO] Installing NodeJS......"

if [ -z ${DIR+x} ]; then 
	#running by itself
	source ../constants.sh
else 
	#running from dendro_full_setup_ubuntu_server_ubuntu_16.sh
	source ./constants.sh
fi

#save current dir
setup_dir=$(pwd)

#install nodejs
sudo apt-get -qq update && sudo apt-get -y -f -qq install git-core python curl build-essential openssl libssl-dev
cd $temp_downloads_folder
sudo rm -rf node
sudo git clone https://github.com/joyent/node.git
cd node
sudo git checkout v0.10.28
sudo ./configure --openssl-libpath=/usr/lib/ssl > /dev/null 2>&1
sudo make --silent > /dev/null > /dev/null 2>&1
sudo make install --silent /dev/null 2>&1

#go back to initial dir
cd $setup_dir

echo "[INFO] Installed NodeJS."
