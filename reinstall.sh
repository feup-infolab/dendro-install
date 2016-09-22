#!/usr/bin/env bash

source ./scripts/constants.sh

read -p "Are you sure that you want to delete the VM named '${active_deployment_setting}' and reinstall it? [y/n]" -n 1 -r
echo 
if [[ $REPLY =~ ^[Yy]$ ]]
then
	#echo "Please enter your administrator password:"
	#destroy dendro vm
	
	source ./define_env_vars.sh
	
	vagrant destroy -f $VAGRANT_VM_NAME || warning "Unable to destroy VM ${active_deployment_setting}"
	#vagrant box update	
	VBoxManage controlvm $VAGRANT_VM_NAME poweroff || warning "Unable to power off VM ${active_deployment_setting}. Does it exist?"
	VBoxManage unregistervm $VAGRANT_VM_NAME -delete || warning "Unable to delete VM ${active_deployment_setting}."

	#clean list of VMs
	vagrant global-status --prune || true 

	info "Starting new VM setup..."

	source ./install.sh
fi
