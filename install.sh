#!/usr/bin/env bash

#compress scripts folder
rm -rf scripts.tar.gz
tar -zcf scripts.tar.gz ./scripts

# start vagrant and provision virtual machine
chmod -R 0777 ~/.vagrant.d
vagrant destroy -f dendro
vagrant up --provider virtualbox --provision

echo "[SUCCESS] Dendro is now installed!"

#clean list of VMs
#sudo vagrant global-status --prune
