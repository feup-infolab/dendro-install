#!/usr/bin/env bash

info "Installing Play Framework 2.2.3......"

if [ -z ${DIR+x} ]; then
	#running by itself
	source ../constants.sh
else
	#running from dendro_full_setup_ubuntu_server_ubuntu_16.sh
	source ./constants.sh
fi

#save current dir
setup_dir=$(pwd) &&

info "Installing Java 8 JDK"
apt-get install --yes python-software-properties
add-apt-repository ppa:webupd8team/java
apt-get update -qq
echo debconf shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections
echo debconf shared/accepted-oracle-license-v1-1 seen true | /usr/bin/debconf-set-selections
apt-get install --yes oracle-java8-installer
yes "" | apt-get -f install

#install play framework
cd $temp_downloads_folder &&

if [ ! -f ./play-2.2.3.zip ]; then
	info "Downloading Play Framework archive to ${temp_downloads_folder}...PLEASE STAND BY!"
	sudo wget --progress=bar:force http://downloads.typesafe.com/play/2.2.3/play-2.2.3.zip
	sudo unzip -qq -o play-2.2.3.zip &&
	info "Download finished. Installing..."
else
	info "Play Framework already downloaded. To force re-download, please run \'rm $temp_downloads_folder/play-2.2.3.zip\' and run the script again."
fi

cd play-2.2.3 &&
sudo rm -rf $play_framework_install_path &&
sudo mkdir $play_framework_install_path &&
sudo mv * $play_framework_install_path ||
die "Failed to install Play Framework."

#go back to initial dir
cd $setup_dir

success "Installed Play Framework."
