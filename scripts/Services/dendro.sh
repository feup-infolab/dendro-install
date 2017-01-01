#!/usr/bin/env bash

if [ -z ${DIR+x} ]; then
	#running by itself
	source ../constants.sh
else
	#running from dendro_full_setup_ubuntu_server_ubuntu_16.sh
	source ./constants.sh
fi

info "Setting up Dendro service...\n"

#printf "/usr/local/bin/node ${dendro_installation_path}/app.js >> ${dendro_log_file} 2>&1"

#save current dir
setup_dir=$(pwd)

#stop current recommender service if present
info "Stopping $dendro_service_name service..."
sudo systemctl stop $dendro_service_name > /dev/null

#setup auto-start dendro service
sudo rm -rf $dendro_startup_item_file
sudo touch $dendro_startup_item_file
sudo chmod 0655 $dendro_startup_item_file

#create pids folder...
sudo mkdir -p $installation_path/service_pids

printf "Dendro Running Service Command:"
printf "\n"
printf "/usr/local/bin/nodejs ${dendro_installation_path}/app.js | tee ${dendro_log_file}"
printf "\n"

printf "[Unit]
Description=Dendro ${active_deployment_setting}  daemon
[Service]
Type=simple
Restart=on-failure
RestartSec=5s
TimeoutStartSec=infinity
User=$dendro_user_name
Group=$dendro_user_group
RuntimeMaxSec=infinity
KillMode=control-group
ExecStart=/bin/sh -c '/usr/bin/nodejs ${dendro_installation_path}/src/app.js >> ${dendro_log_file} 2>&1'
PIDFile=$installation_path/service_pids/${dendro_service_name}
[Install]
WantedBy=multi-user.target\n" | sudo tee $dendro_startup_item_file

sudo chmod 0655 $dendro_startup_item_file
sudo systemctl daemon-reload
sudo systemctl reload
sudo systemctl enable $dendro_service_name
sudo systemctl start $dendro_service_name

#go back to initial dir
cd $setup_dir

success "Finished setting up Dendro service.\n"
