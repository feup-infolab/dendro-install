#!/usr/bin/env bash

if [ -z ${DIR+x} ]; then 
	#running by itself
	source ../../constants.sh
else 
	#running from dendro_full_setup_ubuntu_server_ubuntu_16.sh
	source ./constants.sh
fi

#save current dir
setup_dir=$(pwd)

#setup log file
sudo touch $dendro_log_file
sudo chown -R $dendro_user_name:$dendro_user_group $dendro_log_file
sudo chmod 0666 $dendro_log_file

#go back to initial dir
cd $setup_dir
