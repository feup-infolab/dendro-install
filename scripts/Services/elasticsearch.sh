#!/usr/bin/env bash

echo "[INFO] Setting up ElasticSearch service..."

if [ -z ${DIR+x} ]; then 
	#running by itself
	source ../constants.sh
else 
	#running from dendro_full_setup_ubuntu_server_ubuntu_16.sh
	source ./constants.sh
fi

#save current dir
setup_dir=$(pwd)

#set elasticsearch startup service
sudo systemctl daemon-reload
sudo systemctl enable elasticsearch
sudo systemctl start elasticsearch

#go back to initial dir
cd $setup_dir

echo "[OK] Finished setting up ElasticSearch service."