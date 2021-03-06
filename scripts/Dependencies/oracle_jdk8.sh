#!/usr/bin/env bash

info "Installing Oracle JDK 8......"

if [ -z ${DIR+x} ]; then
	#running by itself
	source ../constants.sh
else
	#running from dendro_full_setup_ubuntu_server_ubuntu_16.sh
	source ./constants.sh
fi

#save current dir
setup_dir=$(pwd) &&

info "Installing Java 8 JDK. This will take a few minutes."
sudo apt-get install --yes python-software-properties
sudo add-apt-repository -y ppa:webupd8team/java
sudo apt-get update -qq
echo debconf shared/accepted-oracle-license-v1-1 select true | sudo /usr/bin/debconf-set-selections
echo debconf shared/accepted-oracle-license-v1-1 seen true | sudo /usr/bin/debconf-set-selections
info "This will take a few minutes and no messages will be shown. PLEASE WAIT!"
sudo apt-get install -qq --yes oracle-java8-installer > /dev/null
yes "" | sudo apt-get -f install > /dev/null || die "There was an error installing Oracle JDK 8."

info "Installing Oracle JDK 8. There is no output but the installation is working in the background. Please WAIT!"
sudo apt install oracle-java8-set-default > /dev/null

#go back to initial dir
cd $setup_dir

success "Installed Oracle JDK 8."
