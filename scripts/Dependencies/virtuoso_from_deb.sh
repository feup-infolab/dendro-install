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

git clone https://github.com/feup-infolab/virtuoso7-debs.git virtuoso7
cd virtuoso7/debs-ubuntu-16-04
sudo dpkg -i virtuoso-opensource7_7.2.4-1_amd64.deb

#go back to initial dir
cd $setup_dir

success "Installed Subversion 1.8."
