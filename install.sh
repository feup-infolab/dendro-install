#!/usr/bin/env bash

source ./scripts/constants.sh

#compress scripts folder
rm -rf scripts.tar.gz
tar -zcf scripts.tar.gz ./scripts

# start vagrant and provision virtual machine
chmod -R 0777 ~/.vagrant.d

SHELL_ARGS=''

while getopts 'atcjudrbs:' flag; do
  case $flag in
    s)
      #revert to last snapshot
      snapshot_id=VBoxManage snapshot $active_deployment_setting list | tail -n 1 | grep -o "UUID.*" | cut -c 7-42
      VBoxManage snapshot $active_deployment_setting restore $snapshot_id
      ;;
    a)
      #install TeamCity
      take_vm_snapshot $active_deployment_setting "install_teamcity_agent"
    	VAGRANT_SHELL_ARGS=$VAGRANT_SHELL_ARGS'-a '
    	;;
    c)
      #install TeamCity Agent
      take_vm_snapshot $active_deployment_setting "install_teamcity"
    	VAGRANT_SHELL_ARGS=$VAGRANT_SHELL_ARGS'-c '
    	;;
    t)
      #Run Tests on Dendro after checkout
      take_vm_snapshot $active_deployment_setting "run_tests"
    	VAGRANT_SHELL_ARGS=$VAGRANT_SHELL_ARGS'-t '
    	;;
    r)
      #refresh only the code of Dendro without installing dependencies
      take_vm_snapshot $active_deployment_setting "refresh_code_only"
		  VAGRANT_SHELL_ARGS=$VAGRANT_SHELL_ARGS'-r '
		  ;;
    d)
      #enable development mode
      take_vm_snapshot $active_deployment_setting "set_dev_mode"
		  VAGRANT_SHELL_ARGS=$VAGRANT_SHELL_ARGS'-d '
		  ;;
    u)
      #disable development mode
      take_vm_snapshot $active_deployment_setting "unset_dev_mode"
		  VAGRANT_SHELL_ARGS=$VAGRANT_SHELL_ARGS'-u '
	    ;;
    j)
      #Install Jenkins
      take_vm_snapshot $active_deployment_setting "install_jenkins"
  		VAGRANT_SHELL_ARGS=$VAGRANT_SHELL_ARGS'-j '
  		;;
	  b)
      #Checkout Dendro branch specified as argument
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
