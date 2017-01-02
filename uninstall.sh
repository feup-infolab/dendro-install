#!/usr/bin/env bash

source ./scripts/constants.sh
source ./define_env_vars.sh

machine_exists()
{
  vbox_name=$3
  fetched_vbox_line=$(VBoxManage list vms | grep -o "\"$vbox_name\".*")
  vbox_exists=$?

  if [ "$vbox_exists" == "0" ]; then
    info "Vbox with name $vbox_name exists."
		eval "$1=\"true\""

    #Mac OS X grep does not accept -P flag for perl regexes unlike GNU grep
    if [ "$OSTYPE" == "linux-gnu" ] || [ "$OSTYPE" == "cygwin" ] || [ "$OSTYPE" == "msys" ]
    then
      found_vbox_id=$(echo $fetched_vbox_line | grep -P -o "[^{}]+")
    elif [[ "$OSTYPE" == "freebsd"* ]] || [[ "$OSTYPE" == "darwin"* ]]
    then
      found_vbox_id=$(echo $fetched_vbox_line | grep -o "{.*}" | grep -o "[^{}]*[^{}]" )
    fi

    if [ "$found_vbox_id" != "" ]; then
      #info "vbox_exists : $vbox_exists. fetched_vbox_id: $found_vbox_id"
  		eval "$2=$found_vbox_id"
  	fi

	else
    info "Vbox with name $vbox_name does not exist."
		eval "$1=\"false\""
	fi
}

vbox_exists="false"
vbox_id=""
machine_exists vbox_exists vbox_id ${active_deployment_setting}

if [ "$vbox_exists" == "true" ] && [ $vbox_id != "" ]
then
  info "Virtualbox ${active_deployment_setting} was found and has ID: $vbox_id"

  vagrant destroy -f ${active_deployment_setting} || warning "Unable to destroy VM ${active_deployment_setting}"
  #clean list of VMs
  vagrant global-status --prune || true

  #if failed, try to destroy via VirtualBox
  vbox_exists="false"
  vbox_id=""
  machine_exists vbox_exists vbox_id ${active_deployment_setting}

  if [ "$vbox_exists" == "true" ] && [ $vbox_id != "" ]
  then
    VBoxManage controlvm $vbox_id poweroff || warning "Unable to power off VM ${active_deployment_setting}. Does it exist?"
    VBoxManage unregistervm $vbox_id -delete || warning "Unable to delete VM ${active_deployment_setting}."
    rm -rf "$HOME/Virtualbox\ VMs\\${active_deployment_setting}"
    vagrant global-status --prune || true
  fi

  vbox_exists="false"
  vbox_id=""
  machine_exists vbox_exists vbox_id ${active_deployment_setting}

  if [[ "$vbox_exists" == "0" ]]
  then
    die "Virtualbox still exists, unable to delete"
  fi

  rm -rf .\.vagrant
else
  warning "Virtualbox does not exist, there is nothing to delete."
fi
