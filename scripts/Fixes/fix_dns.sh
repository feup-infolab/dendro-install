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

IFS='%'
read -r -d '' old_line << BUFFERDELIMITER
127.0.0.1       localhost
BUFFERDELIMITER
unset IFS

IFS='%'
read -r -d '' new_line << BUFFERDELIMITER
127.0.0.1       localhost
127.0.0.1       $host
BUFFERDELIMITER
unset IFS

patch_file "/etc/hosts" "$old_line" "$new_line" "localhost_dns_patch" "sh" && success "Patched hostname $host to 127.0.0.1." || die "Unable to patch /etc/hosts to refer to $host as 127.0.0.1."


success "Applied DNS resolution fix."

#go back to initial dir
cd $setup_dir
