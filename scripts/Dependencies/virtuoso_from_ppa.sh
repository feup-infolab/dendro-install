#!/usr/bin/env bash

if [ -z ${DIR+x} ]; then
	#running by itself
	source ../constants.sh
else
	#running from dendro_full_setup_ubuntu_server_ubuntu_16.sh
	source ./constants.sh
fi

info "Installing Virtuoso 7.1.1 From PPA......"

#save current dir
setup_dir=$(pwd)

#install Virtuoso 7.1.1 from PPA

echo "deb http://packages.comsode.eu/debian wheezy main" | sudo tee -a /etc/apt/sources.list.d/odn.list
wget -O - http://packages.comsode.eu/key/odn.gpg.key | sudo apt-key add -
sudo apt-get update
sudo apt-get install -y virtuoso-opensource=7.2

#go back to initial dir
cd $setup_dir

success "Installed Subversion 1.8."
