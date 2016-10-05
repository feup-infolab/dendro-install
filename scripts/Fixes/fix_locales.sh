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

info "Fixing Locales..."

export LC_ALL="en_US.UTF-8"
export LC_CTYPE="en_US.UTF-8"

success "Applied Locales Fix."

#go back to initial dir
cd $setup_dir
