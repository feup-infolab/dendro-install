#!/usr/bin/env bash
source ./scripts/constants.sh

VBoxManage list vms | grep dendroVagrantDemo > /dev/null
vbox_exists=$?

if [[ "$vbox_exists" == "0" ]]
then
  vbox_id="{$(VBoxManage list vms | grep -o "{.*}" | grep -P -o "[^{}]+")}"

  info "Virtualbox ${active_deployment_setting} was found and has ID: $vbox_id"

  vagrant destroy -f ${active_deployment_setting} || warning "Unable to destroy VM ${active_deployment_setting}"
  VBoxManage controlvm $vbox_id poweroff || warning "Unable to power off VM ${active_deployment_setting}. Does it exist?"
  VBoxManage unregistervm $vbox_id -delete || warning "Unable to delete VM ${active_deployment_setting}."

  rm -rf .\.vagrant

  #clean list of VMs
  vagrant global-status --prune || true

  VBoxManage list vms | grep dendroVagrantDemo > /dev/null
  vbox_exists=$?

  exit 1

  if [[ "$vbox_exists" == "0" ]]
  then
    die "Virtualbox still exists, unable to delete"
  fi

fi
