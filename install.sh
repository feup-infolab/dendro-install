#!/usr/bin/env bash

#reset seconds variable
SECONDS=0

source ./scripts/constants.sh

#compress scripts folder
rm -rf scripts.tar.gz
tar -zcf scripts.tar.gz ./scripts

# start vagrant and provision virtual machine
chmod -R 0777 ~/.vagrant.d

SHELL_ARGS=''

snapshot_name=""

append_to_snapshot_name()
{
  new_name=$1
  if [[ "$snapshot_name" -eq "" ]]
  then
    snapshot_name=$new_name
  else
    snapshot_name="$snapshot_name-$new_name"
  fi
}

while getopts 'satcjudrb:' flag; do
  case $flag in
    s)
      revert_to_last_snapshot="true"
      ;;
    a)
      #install TeamCity
      append_to_snapshot_name "install_teamcity_agent"
      VAGRANT_SHELL_ARGS=$VAGRANT_SHELL_ARGS'-a '
      ;;
    c)
      #install TeamCity Agent
      append_to_snapshot_name "install_teamcity"
    	VAGRANT_SHELL_ARGS=$VAGRANT_SHELL_ARGS'-c '
    	;;
    t)
      #Run Tests on Dendro after checkout
      append_to_snapshot_name "run_tests"
    	VAGRANT_SHELL_ARGS=$VAGRANT_SHELL_ARGS'-t '
    	;;
    r)
      #refresh only the code of Dendro without installing dependencies
      append_to_snapshot_name "refresh_code_only"
		  VAGRANT_SHELL_ARGS=$VAGRANT_SHELL_ARGS'-r '
		  ;;
    d)
      #enable development mode
      append_to_snapshot_name "set_dev_mode"
		  VAGRANT_SHELL_ARGS=$VAGRANT_SHELL_ARGS'-d '
		  ;;
    u)
      #disable development mode
      append_to_snapshot_name "unset_dev_mode"
		  VAGRANT_SHELL_ARGS=$VAGRANT_SHELL_ARGS'-u '
	    ;;
    j)
      #Install Jenkins
      append_to_snapshot_name "install_jenkins"
  		VAGRANT_SHELL_ARGS=$VAGRANT_SHELL_ARGS'-j '
  		;;
	  b)
      #Checkout Dendro branch specified as argument
      append_to_snapshot_name "install_with_branch_$OPTARG"
		  VAGRANT_SHELL_ARGS="$VAGRANT_SHELL_ARGS-b $OPTARG "
		  ;;
    *)
		  error "Unexpected option $flag"
		  ;;
  esac
done

if [[ "$revert_to_last_snapshot" = "true" ]]
then
  #revert to last snapshot
  warning "Reverting to last snapshot before proceeding with operations...."
  snapshot_id=$(VBoxManage snapshot $active_deployment_setting list | tail -n 1 | grep -o "UUID.*" | cut -c 7-42)
  source ./halt_vm.sh
  VBoxManage snapshot $active_deployment_setting restore $snapshot_id
else
  take_vm_snapshot $active_deployment_setting $snapshot_name
fi

source ./define_env_vars.sh
export VAGRANT_VM_INSTALL='true'

info "Running vagrant halt..."
vagrant halt -f

#create shared folders if they dont exist already
if [[ ! -d "shared_folders/dendro" ]]
then
	mkdir -p "shared_folders/dendro"
fi

if [[ ! -d "shared_folders/etc/init.d" ]]
then
	mkdir -p "shared_folders/etc/init.d"
fi

info "Running vagrant up..."
#vagrant box update
if [ "$JENKINS_BUILD" == "1" ]
then
  export VAGRANT_LOG="info"
  vagrant up --provider virtualbox --provision ||
  die "There were errors installing Dendro."
  unset VAGRANT_LOG
else
  vagrant up --provider virtualbox --provision ||
  die "There were errors installing Dendro."
fi

info "Cleaning up..."
rm ./scripts.tar.gz
success "Deleted temporary scripts package."

#print time elapsed
duration=$SECONDS
info "$(($duration / 60)) minutes and $(($duration % 60)) seconds elapsed."

#clean list of VMs
#sudo vagrant global-status --prune
