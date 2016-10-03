#!/usr/bin/env bash

if [ -z ${DIR+x} ]; then
	#running by itself
	source ../constants.sh
else
	#running from dendro_full_setup_ubuntu_server_ubuntu_16.sh
	source ./constants.sh
fi

info "Installing latest MongoDB......"

#save current dir
setup_dir=$(pwd)

sudo rm -rf /etc/systemd/system/mongodb.service &&
sudo touch /etc/systemd/system/mongodb.service &&

#create pids folder...
sudo mkdir -p $dendro_installation_path/service_pids &&

printf "[Unit]
Description=High-performance, schema-free document-oriented database
\n
[Service]
Type=simple
Restart=on-failure
RestartSec=5s
RuntimeMaxSec=infinity
TimeoutStartSec=infinity
Environment=HOME=/root
User=mongodb
Group=mongodb
ExecStart=/usr/bin/mongod --quiet
PIDFile=$installation_path/service_pids/mongodb.pid
\n
[Install]
WantedBy=multi-user.target\n" | sudo tee /etc/systemd/system/mongodb.service &&

sudo chown mongodb /data/db/mongod.lock
sudo chown -R mongodb /data/db

#set elasticsearch startup service
sudo chmod 0744 /etc/systemd/system/mongodb.service &&
sudo systemctl daemon-reload &&
sudo systemctl enable mongodb &&
sudo systemctl unmask mongodb || die "Unable to create MongoDB service"
sudo systemctl start mongodb || die "Unable to start MongoDB service"

#go back to initial dir
cd $setup_dir

success "Finished setting up MongoDB service."
