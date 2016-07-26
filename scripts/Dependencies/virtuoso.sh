#!/usr/bin/env bash

echo "[INFO] Installing OpenLink Virtuoso 7......"

if [ -z ${DIR+x} ]; then 
	#running by itself
	source ../constants.sh
else 
	#running from dendro_full_setup_ubuntu_server_ubuntu_16.sh
	source ./constants.sh
fi

#save current dir
setup_dir=$(pwd)

#install virtuoso opensource 7
cd $temp_downloads_folder
sudo rm -rf virtuoso-opensource
sudo git clone https://github.com/openlink/virtuoso-opensource.git virtuoso-opensource
cd virtuoso-opensource
sudo git branch remotes/origin/develop/7
sudo ./autogen.sh
CFLAGS="-O2 -m64"
export CFLAGS
sudo ./configure > /dev/null 2>&1
sudo make --silent > /dev/null 2>&1
sudo make install --silent /dev/null 2>&1

#create virtuoso user and give ownership
sudo useradd $virtuoso_user 
sudo addgroup $virtuoso_group
sudo usermod $virtuoso_user -g $virtuoso_group
echo "${virtuoso_user}:${virtuoso_user_password}" | sudo chpasswd
sudo chown -R $virtuoso_user:$virtuoso_group /usr/local/virtuoso-opensource

echo "[OK] Installed OpenLink Virtuoso 7."

#go back to initial dir
cd $setup_dir

