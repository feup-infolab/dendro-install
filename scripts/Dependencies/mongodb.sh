#!/usr/bin/env bash

if [ -z ${DIR+x} ]; then 
	#running by itself
	source ../constants.sh
else 
	#running from dendro_full_setup_ubuntu_server_ubuntu_16.sh
	source ./constants.sh
fi

info "Installing MongoDB Community Edition......"

#save current dir
setup_dir=$(pwd) &&

#install Java 8
sudo apt-get install -y python-software-properties debconf-utils
sudo add-apt-repository -y ppa:webupd8team/java
sudo apt-get update
echo "oracle-java8-installer shared/accepted-oracle-license-v1-1 select true" | sudo debconf-set-selections
sudo apt-get install -y oracle-java8-installer

#install mongodb 10g
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 0C49F3730359A14518585931BC711F9BA15703C6 && 
echo "deb [ arch=amd64,arm64 ] http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.4 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.4.list &&
sudo apt-get -qq update &&
sudo apt-get -y install -f mongodb-org &&
sudo systemctl enable mongod.service && 
sudo systemctl daemon-reload &&
sudo service mongod start &&
sudo service mongod restart || die "Unable to start mongodb service!"

sudo mkdir -p /data/db &&
sudo chown -R mongodb /data/db &&

#go back to initial dir
cd $setup_dir && 
success "Installed latest MongoDB Community Edition." ||
die "Failed to install latest MongoDB Community Edition." 

#SCRAP

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

# command="cat /etc/environment | grep '${line}'"
# echo $command
# result=$(command)
# echo "Result = ${result}"

# sudo rm -rf /etc/environment.bak_before_dendro_setup

# #install MongoDB (because the official guide does not work...)
# #https://stackoverflow.com/questions/28945921/e-unable-to-locate-package-mongodb-org
#
# #Step 1:  Import the MongoDB public key
# sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 58712A2291FA4AD5
#
# #Step 2: Generate a file with the MongoDB repository url
# echo "deb http://repo.mongodb.org/apt/ubuntu "$(lsb_release -sc)"/mongodb-org/3.5 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.5.list
#
# #Step 3: Refresh the local database with the packages
# sudo apt-get update
#
# #Step 4: Install the last stable MongoDB version and all the necessary packages on our system
# sudo apt-get install mongodb
#
# #Because sometimes this folder is not created properly... go figure.
# sudo mkdir -p /data/db
# sudo chown -R mongodb /data/db



