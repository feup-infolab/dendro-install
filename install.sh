#!/usr/bin/env bash

#compress scripts folder
rm -rf scripts.tar.gz
tar -zcf scripts.tar.gz ./scripts

# start vagrant and provision virtual machine
chmod -R 0777 ~/.vagrant.d
vagrant destroy -f dendro
vagrant up --provider virtualbox --provision

printf "${Green}[END]${Color_Off} Dendro setup complete.\n"

#clean list of VMs
#sudo vagrant global-status --prune
