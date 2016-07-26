#!/usr/bin/env bash

echo "[INFO] Installing Play Framework 2.2.3......"

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

echo debconf shared/accepted-oracle-license-v1-1 select true | sudo debconf-set-selections
echo debconf shared/accepted-oracle-license-v1-1 seen true | sudo debconf-set-selections

sudo apt-get -y install oracle-java8-installer

#install play framework
cd $temp_downloads_folder

if [ ! -f ./play-2.2.3.zip ]; then
	echo "[INFO] Downloading Play Framework archive to ${temp_downloads_folder}...PLEASE STAND BY!"
	sudo wget --progress=bar:force http://downloads.typesafe.com/play/2.2.3/play-2.2.3.zip
else
	echo "[INFO] Play Framework already downloaded. To force re-download, please run \'rm $temp_downloads_folder/play-2.2.3.zip\' and run the script again."
fi

sudo unzip -qq play-2.2.3.zip

echo "[OK] Download finished!"

cd play-2.2.3
rm -rf $play_framework_install_path
mkdir $play_framework_install_path
mv * $play_framework_install_path

#go back to initial dir
cd $setup_dir

echo "[OK] Downloaded Play Framework 2.2.3."

