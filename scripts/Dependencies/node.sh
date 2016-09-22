#!/usr/bin/env bash

if [ -z ${DIR+x} ]; then 
	#running by itself
	source ../constants.sh
else 
	#running from dendro_full_setup_ubuntu_server_ubuntu_16.sh
	source ./constants.sh
fi

info "Installing NodeJS......\n"

#save current dir
setup_dir=$(pwd)

#install nodejs
sudo apt-get -qq update && sudo apt-get -y -f -qq install git-core python curl build-essential openssl libssl-dev &&
cd $temp_downloads_folder &&
sudo rm -rf node &&
sudo git clone https://github.com/nodejs/node.git &&
cd node &&
sudo ./configure &&
sudo make --silent > /dev/null &&
sudo make install --silent || 
sudo npm install -g bower
die "Failed to install NodeJS." 

#go back to initial dir
cd $setup_dir

success "$Installed NodeJS.\n"
