#!/usr/bin/env bash

echo "[INFO] Installing Preliminary Dependencies......"

if [ -z ${DIR+x} ]; then 
	#running by itself
	source ../constants.sh
else 
	#running from dendro_full_setup_ubuntu_server_ubuntu_16.sh
	source ./constants.sh
fi

#save current dir
setup_dir=$(pwd)

sudo apt-get -y -f -qq install autoconf automake libtool flex bison gperf gawk m4 make libssl-dev git imagemagick subversion zip htop --fix-missing

#go back to initial dir
cd $setup_dir

echo "[OK] Installed Preliminary Dependencies."

