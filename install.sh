#!/usr/bin/env bash

source ./scripts/constants.sh

#compress scripts folder
rm -rf scripts.tar.gz
tar -zcf scripts.tar.gz ./scripts

# start vagrant and provision virtual machine
chmod -R 0777 ~/.vagrant.d

SHELL_ARGS=''

while getopts 'tjusdrb:' flag; do
  case $flag in
    t)
    	VAGRANT_SHELL_ARGS=$VAGRANT_SHELL_ARGS'-t '
    	;;
    s)
  		VAGRANT_SHELL_ARGS=$VAGRANT_SHELL_ARGS'-s '
  		;;
    r)
		VAGRANT_SHELL_ARGS=$VAGRANT_SHELL_ARGS'-r '
		;;
	d)
		VAGRANT_SHELL_ARGS=$VAGRANT_SHELL_ARGS'-d '
		;;
	u)
		VAGRANT_SHELL_ARGS=$VAGRANT_SHELL_ARGS'-u '
		;;
    j)
  		VAGRANT_SHELL_ARGS=$VAGRANT_SHELL_ARGS'-j '
  		;;
	b)
		VAGRANT_SHELL_ARGS="$VAGRANT_SHELL_ARGS-b $OPTARG "
		;;
    *)
		error "Unexpected option ${flag}"
		;;
  esac

done

source ./define_env_vars.sh
export VAGRANT_VM_INSTALL='true'

vagrant halt
#vagrant box update
vagrant up --provider virtualbox --provision ||
die "There were errors installing Dendro."

info "Cleaning up..."
rm ./scripts.tar.gz
success "Deleted temporary scripts package."

#clean list of VMs
#sudo vagrant global-status --prune
