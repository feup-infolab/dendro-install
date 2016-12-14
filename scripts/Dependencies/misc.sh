#!/usr/bin/env bash

if [ -z ${DIR+x} ]; then
	#running by itself
	source ../constants.sh
else
	#running from dendro_full_setup_ubuntu_server_ubuntu_16.sh
	source ./constants.sh
fi

info "Installing Preliminary Dependencies....PLEASE WAIT, as this will take several minutes."
info "NOTE: To setup this Virtual Machine for Development, use the -d flag. Example: ./install.sh -d"

#save current dir
setup_dir=$(pwd)

sudo apt-get -y -f -qq install devscripts autoconf automake libtool flex bison gperf gawk m4 make libssl-dev git imagemagick subversion zip htop redis-server nodejs npm --fix-missing || die "Failed to install preliminary dependencies. Please check any prior error messages."

#install bower
sudo npm install -g bower

#alias nodejs to node
sudo ln -s `which nodejs` /usr/bin/node

#go back to initial dir
cd $setup_dir

success "Installed Preliminary Dependencies."
