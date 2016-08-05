#!/usr/bin/env bash

printf "${Cyan}[INFO]${Color_Off} Installing Play Framework 2.2.3......\n"

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
sudo add-apt-repository -y ppa:webupd8team/java
sudo apt-get -qq update

echo debconf shared/accepted-oracle-license-v1-1 select true | sudo debconf-set-selections
echo debconf shared/accepted-oracle-license-v1-1 seen true | sudo debconf-set-selections

sudo apt-get -y install oracle-java8-installer

#install play framework
cd $temp_downloads_folder

if [ ! -f ./play-2.2.3.zip ]; then
	printf "${Cyan}[INFO]${Color_Off} Downloading Play Framework archive to ${temp_downloads_folder}...PLEASE STAND BY!"
	sudo wget --progress=bar:force http://downloads.typesafe.com/play/2.2.3/play-2.2.3.zip
else
	printf "${Cyan}[INFO]${Color_Off} Play Framework already downloaded. To force re-download, please run \'rm $temp_downloads_folder/play-2.2.3.zip\' and run the script again."
fi

sudo unzip -qq -o play-2.2.3.zip

printf "${Cyan}[INFO]${Color_Off} Download finished. Installing...\n"

cd play-2.2.3
sudo rm -rf $play_framework_install_path
sudo mkdir $play_framework_install_path
sudo mv * $play_framework_install_path

#go back to initial dir
cd $setup_dir

printf "${Green}[OK]${Color_Off} Downloaded Play Framework 2.2.3.\n"

