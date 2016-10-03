#!/usr/bin/env bash

if [ -z ${DIR+x} ]; then
	#running by itself
	source ../../constants.sh
else
	#running from dendro_full_setup_ubuntu_server_ubuntu_16.sh
	source ./constants.sh
fi

#save current dir
setup_dir=$(pwd)

info "Fixing DNS resolution..."

sudo rm /etc/resolv.conf &&
sudo ln -s ../run/resolvconf/resolv.conf /etc/resolv.conf &&
sudo resolvconf -u || die "Unable to run DNS fixing commands."

success "Applied DNS resolution fix."

#go back to initial dir
cd $setup_dir
