#!/usr/bin/env bash

if [ -z ${DIR+x} ]; then 
	#running by itself
	source ../constants.sh
else 
	#running from dendro_full_setup_ubuntu_server_ubuntu_16.sh
	source ./constants.sh
fi

#save current dir
setup_dir=$(pwd)

sudo useradd $dendro_user_name
sudo addgroup $dendro_user_group
sudo usermod $dendro_user_name -g $dendro_user_group
echo "${dendro_user_name}:${dendro_user_password}" | sudo chpasswd

#go back to initial dir
cd $setup_dir