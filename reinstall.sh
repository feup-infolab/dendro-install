#!/usr/bin/env bash

source ./scripts/constants.sh

read -p "Are you sure that you want to delete the VM named '${active_deployment_setting}' and reinstall it? [y/n]" -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
	#echo "Please enter your administrator password:"
	#destroy dendro vm

	source ./define_env_vars.sh

	info "Removing existing ${active_deployment_setting} VM..."
	source ./uninstall.sh

	info "Starting new VM setup..."

	source ./install.sh
fi
