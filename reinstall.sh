#!/usr/bin/env bash

#save current directory
starting_dir=$(pwd)

source ./scripts/constants.sh

read -p "Are you sure that you want to delete the VM named '${active_deployment_setting}' and reinstall it? [y/n]" -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
	#echo "Please enter your administrator password:"
	#destroy dendro vm

	info "Deleting all *.vmdk in $starting_dir"
	rm $starting_dir/*.vmdk

	info "Deleting all *.vdi in $starting_dir"
	rm $starting_dir/*.vdi

	[[ "$active_deployment_setting" -ne "" ]]
	info "Active dep setting not empty? $?"

	[[ -d "$HOME/VirtualBox VMs/$active_deployment_setting" ]]
	info "Folder exists? $?"

	if [ "$active_deployment_setting" != "" ] && [ -d "$HOME/VirtualBox VMs/$active_deployment_setting" ];
	then
		rm -rf "$HOME/VirtualBox VMs/$active_deployment_setting"
	fi

	source ./define_env_vars.sh

	info "Removing existing ${active_deployment_setting} VM..."
	source ./uninstall.sh

	info "Starting new VM setup..."

	source ./install.sh
fi
