#!/usr/bin/env bash

echo "[INFO] Installing latest MongoDB......"

if [ -z ${DIR+x} ]; then 
	#running by itself
	source ../constants.sh
else 
	#running from dendro_full_setup_ubuntu_server_ubuntu_16.sh
	source ./constants.sh
fi

#save current dir
setup_dir=$(pwd)

#install Java 8
sudo add-apt-repository ppa:webupd8team/java
sudo apt-get -qq update
sudo apt-get -qq install oracle-java8-installer

#install mongodb 10g
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10
echo 'deb http://downloads-distro.mongodb.org/repo/ubuntu-upstart dist 10gen' | sudo tee /etc/apt/sources.list.d/mongodb.list
sudo apt-get -qq update
sudo apt-get -y -qq install -f mongodb-10gen

sudo mkdir -p /data/db/
sudo chown `id -u` /data/db

#Apply locales fix...
# line="LC_ALL=\"en_GB.utf8\""
#
# if [ -f /etc/environment.bak_before_dendro_setup ]
# then
# 	echo "[INFO] Locales fix already applied. Continuing..."
# else
# 	echo "[INFO] Adding locales fix..."
# 	sudo cp /etc/environment /etc/environment.bak_before_dendro_setup
# 	echo $line | sudo tee -a /etc/environment
# fi
	
#go back to initial dir
cd $setup_dir

echo "[OK] Installed latest MongoDB."


#SCRAP

# command="cat /etc/environment | grep '${line}'"
# echo $command
# result=$(command)
# echo "Result = ${result}"

# sudo rm -rf /etc/environment.bak_before_dendro_setup



