#!/usr/bin/env bash

source ./scripts/constants.sh

export VAGRANT_SHELL_ARGS=$VAGRANT_SHELL_ARGS
info "Shell arguments for Vagrant: ${VAGRANT_SHELL_ARGS}"

export VAGRANT_VM_NAME=$active_deployment_setting
info "Name of new VM: ${VAGRANT_VM_NAME}"

export VAGRANT_VM_IP=$host
info "IP of new VM: ${VAGRANT_VM_IP}"
