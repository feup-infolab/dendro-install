#!/usr/bin/env bash

if [ -z ${DIR+x} ]; then
	#running by itself
	source ../constants.sh
else
	#running from dendro_full_setup_ubuntu_server_ubuntu_16.sh
	source ./constants.sh
fi

info "Setting up Dendro service...\n"

#save current dir
setup_dir=$(pwd)

#stop current recommender service if present
info "Stopping $dendro_service_name service..."
sudo systemctl stop $dendro_service_name > /dev/null

sudo rm $dendro_startup_item_file
cd $dendro_installation_path

#get the create service command, generated by pm2
CREATE_SERVICE_COMMAND=$(sudo su $dendro_user_name -c "pm2 startup --service-name $dendro_service_name | tail -n 1")

#create service command
info "Running command: $CREATE_SERVICE_COMMAND ..."

#execute the command
eval $CREATE_SERVICE_COMMAND

sudo systemctl daemon-reload
sudo systemctl restart $dendro_service_name

#go back to initial dir
cd $setup_dir || die "Error returning to setup folder"

success "Finished setting up Dendro service.\n"
