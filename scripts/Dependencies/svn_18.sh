#!/usr/bin/env bash

if [ -z ${DIR+x} ]; then 
	#running by itself
	source ../constants.sh
else 
	#running from dendro_full_setup_ubuntu_server_ubuntu_16.sh
	source ./constants.sh
fi

info "Installing Subversion 1.8......"

#save current dir
setup_dir=$(pwd)

#install SVN 1.8
sudo sh -c 'echo "deb http://opensource.wandisco.com/ubuntu precise svn18" >> /etc/apt/sources.list.d/subversion18.list'
sudo wget --progress=bar:force http://opensource.wandisco.com/wandisco-debian.gpg -O- | sudo apt-key add -
sudo apt-get -qq update > /dev/null
sudo apt-cache show subversion | grep '^Version:'
sudo apt-get -qq install subversion
sudo dpkg -l | grep subversion
svn --version


#go back to initial dir
cd $setup_dir

success "Installed Subversion 1.8."
