#!/usr/bin/env bash

if [ -z ${DIR+x} ]; then 
	#running by itself
	source ../constants.sh
else 
	#running from dendro_full_setup_ubuntu_server_ubuntu_16.sh
	source ./constants.sh
fi

printf "${Cyan}[INFO]${Color_Off} Setting up ElasticSearch service...\n"

#save current dir
setup_dir=$(pwd)

#set elasticsearch startup service
sudo systemctl daemon-reload
sudo systemctl enable elasticsearch
sudo systemctl start elasticsearch

#go back to initial dir
cd $setup_dir

printf "${Green}[OK]${Color_Off} Finished setting up ElasticSearch service.\n"