#!/usr/bin/env bash

source ./scripts/constants.sh

export VAGRANT_SHELL_ARGS=$VAGRANT_SHELL_ARGS
info "Shell arguments for Vagrant: ${VAGRANT_SHELL_ARGS}"

export VAGRANT_VM_NAME=$active_deployment_setting
info "Name of new VM: ${VAGRANT_VM_NAME}"

export VAGRANT_VM_IP=$host
info "IP of new VM: ${VAGRANT_VM_IP}"

#THIS DOES NOT WORK AS IT SHOULD.
#export VAGRANT_VM_SSH_USERNAME=$VAGRANT_VM_SSH_USERNAME
#info "USERNAME of SSH user for new VM: ${VAGRANT_VM_SSH_USERNAME}"

#export VAGRANT_VM_SSH_PASSWORD=$VAGRANT_VM_SSH_PASSWORD
#info "PASSWORD of SSH user for new VM: ${VAGRANT_VM_SSH_PASSWORD}"