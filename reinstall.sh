#!/usr/bin/env bash

read -p "Are you sure that you want to ${Red}DELETE${Color_Off} the VM named '${Cyan}dendro${Color_Off}' and reinstall it again? [y/n]" -n 1 -r
echo 
if [[ $REPLY =~ ^[Yy]$ ]]
then
	#destroy dendro vm
	vagrant destroy -f dendro || true
	sudo VBoxManage controlvm dendro poweroff || true
	sudo VBoxManage unregistervm dendro -delete || true

	#clean list of VMs
	sudo vagrant global-status --prune || true

	printf "${Red}[OK]${Color_Off} Old Dendro VM deleted.\n"

	printf "${Cyan}[INFO]${Color_Off} Starting new VM setup...\n"

	source ./install.sh
fi
