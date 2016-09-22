#!/usr/bin/env bash

if [ -z ${DIR+x} ]; then 
	#running by itself
	source ../constants.sh
else 
	#running from dendro_full_setup_ubuntu_server_ubuntu_16.sh
	source ./constants.sh
fi

info "Installing MySQL....."

#save current dir
setup_dir=$(pwd) &&

#install mysql

#configure root password 
#from http://stackoverflow.com/questions/7739645/install-mysql-on-ubuntu-without-password-prompt
sudo apt-get install debconf-utils &&

sudo debconf-set-selections <<< "mysql-server mysql-server/root_password password ${mysql_root_password}" &&
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password_again password ${mysql_root_password}" &&

#sudo apt-get -y -qq remove mysql-server
sudo apt-get -y -qq install mysql-server ||
die "Failed to install MySQL Server."

#go back to initial dir
cd $setup_dir

success "Installed MySQL Server."
