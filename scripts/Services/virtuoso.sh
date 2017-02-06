#!/usr/bin/env bash

#save current dir
setup_dir=$(pwd)

if [ -z ${DIR+x} ]; then
	#running by itself
	source ../constants.sh
else
	#running from dendro_full_setup_ubuntu_server_ubuntu_16.sh
	source ./constants.sh
fi

info "Setting up Virtuoso service..."

#create pids folder...
sudo mkdir -p $dendro_installation_path/service_pids

#set virtuoso startup service
sudo rm -rf $virtuoso_startup_item_file
sudo touch $virtuoso_startup_item_file

printf "[Unit]
Description=Virtuoso Server Daemon
Author=Joao Rocha
\n
[Service]
Type=simple
Restart=on-failure
RestartSec=5s
TimeoutStartSec=infinity
RuntimeMaxSec=infinity
Environment=HOME=/root
User=${virtuoso_user}
Group=${virtuoso_group}
ExecStart=/usr/local/virtuoso-opensource/bin/virtuoso-t -f -c /usr/local/virtuoso-opensource/var/lib/virtuoso/db/virtuoso.ini
PIDFile=${installation_path}/service_pids/virtuoso.pid
\n
[Install]
WantedBy=multi-user.target
Alias=virtuoso.service" | sudo tee $virtuoso_startup_item_file

sudo chmod 0644 $virtuoso_startup_item_file
sudo systemctl daemon-reload
sudo systemctl enable virtuoso
sudo systemctl unmask virtuoso
sudo systemctl start virtuoso

#go back to initial dir
cd $setup_dir

success "Finished setting up Virtuoso service."
