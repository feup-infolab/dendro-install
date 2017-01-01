#!/usr/bin/env bash

source ./scripts/constants.sh

#compress scripts folder
rm -rf scripts.tar.gz
tar -zcf scripts.tar.gz ./scripts

# start vagrant and provision virtual machine
chmod -R 0777 ~/.vagrant.d

SHELL_ARGS=''

while getopts 'atcjudrb:' flag; do
  case $flag in
    a)
      take_vm_snapshot $active_deployment_setting "install_teamcity_agent"
    	VAGRANT_SHELL_ARGS=$VAGRANT_SHELL_ARGS'-a '
    	;;
    c)
      take_vm_snapshot $active_deployment_setting "install_teamcity"
    	VAGRANT_SHELL_ARGS=$VAGRANT_SHELL_ARGS'-c '
    	;;
    t)
      take_vm_snapshot $active_deployment_setting "run_tests"
    	VAGRANT_SHELL_ARGS=$VAGRANT_SHELL_ARGS'-t '
    	;;
    r)
      take_vm_snapshot $active_deployment_setting "refresh_code_only"
		  VAGRANT_SHELL_ARGS=$VAGRANT_SHELL_ARGS'-r '
		  ;;
    d)
      take_vm_snapshot $active_deployment_setting "set_dev_mode"
		  VAGRANT_SHELL_ARGS=$VAGRANT_SHELL_ARGS'-d '
		  ;;
    u)
      take_vm_snapshot $active_deployment_setting "unset_dev_mode"
		  VAGRANT_SHELL_ARGS=$VAGRANT_SHELL_ARGS'-u '
	    ;;
    j)
      take_vm_snapshot $active_deployment_setting "install_jenkins"
  		VAGRANT_SHELL_ARGS=$VAGRANT_SHELL_ARGS'-j '
  		;;
	  b)
      take_vm_snapshot $active_deployment_setting "install_with_branch_$OPTARG"
		  VAGRANT_SHELL_ARGS="$VAGRANT_SHELL_ARGS-b $OPTARG "
		  ;;
    *)
		  error "Unexpected option $flag"
		  ;;
  esac
done

source ./define_env_vars.sh
export VAGRANT_VM_INSTALL='true'

info "Running vagrant halt..."
vagrant halt -f

info "Running vagrant up..."
#vagrant box update
vagrant up --provider virtualbox --provision ||
die "There were errors installing Dendro."

info "Cleaning up..."
rm ./scripts.tar.gz
success "Deleted temporary scripts package."

#clean list of VMs
#sudo vagrant global-status --prune
