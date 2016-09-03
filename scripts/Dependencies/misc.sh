#!/usr/bin/env bash

if [ -z ${DIR+x} ]; then 
	#running by itself
	source ../constants.sh
else 
	#running from dendro_full_setup_ubuntu_server_ubuntu_16.sh
	source ./constants.sh
fi

printf "${Cyan}[INFO]${Color_Off} Installing Preliminary Dependencies......\n"

#save current dir
setup_dir=$(pwd)

sudo apt-get -y -f -qq install autoconf automake libtool flex bison gperf gawk m4 make libssl-dev git imagemagick subversion zip htop redis-server --fix-missing

#go back to initial dir
cd $setup_dir

printf "${Green}[OK]${Color_Off} Installed Preliminary Dependencies.\n"

