#!/usr/bin/env bash

source ./scripts/constants.sh

#compress scripts folder
rm -rf scripts.tar.gz
tar -zcf scripts.tar.gz ./scripts

# start vagrant and provision virtual machine
chmod -R 0777 ~/.vagrant.d

SHELL_ARGS=''

while getopts 'r' flag; do
  case $flag in
    r)
		VAGRANT_SHELL_ARGS=$VAGRANT_SHELL_ARGS'-r '
		;;
    *)
		error "Unexpected option ${flag}"
		;;
  esac

done

source ./define_env_vars.sh
export VAGRANT_VM_INSTALL='true'

#vagrant box update &&
vagrant up --provider virtualbox --provision ||
die "There were errors installing Dendro."

info "Cleaning up..."
rm ./scripts.tar.gz
success "Deleted temporary scripts package."

success "Dendro setup complete."

#clean list of VMs
#sudo vagrant global-status --prune
