#!/usr/bin/env bash

if [ -z ${DIR+x} ]; then
	#running by itself
	source ../constants.sh
else
	#running from dendro_full_setup_ubuntu_server_ubuntu_16.sh
	source ./constants.sh
fi

info "Installing Preliminary Dependencies....PLEASE WAIT, as this will take several minutes."
info "NOTE: To setup this Virtual Machine for Development, use the -d flag. Example: ./install.sh -d"

#save current dir
setup_dir=$(pwd)

sudo apt-get update &&
sudo apt-get -y -f -qq install unzip devscripts autoconf automake libtool flex bison gperf gawk m4 make libssl-dev git imagemagick subversion zip htop redis-server htop mongodb --fix-missing || die "Failed to install preliminary dependencies. Please check any prior error messages."

info "Installing text extraction tools..."
#install text extraction stuff
# (needed for https://github.com/dbashford/textract)
sudo apt-get -y -f install poppler-utils antiword unrtf tesseract-ocr || die "Unable to install text extraction dependencies."

#install vim plugins
#http://vim.spf13.com/#install
#curl http://j.mp/spf13-vim3 -L -o - | sh

#go back to initial dir
cd $setup_dir || die "Unable to return to setup directory while installing base dependencies"

success "Installed Preliminary Dependencies."
