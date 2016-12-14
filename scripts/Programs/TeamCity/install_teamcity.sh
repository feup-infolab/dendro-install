#!/usr/bin/env bash

if [ -z ${DIR+x} ]; then
	#running by itself
	source ../../constants.sh
else
	#running from dendro_full_setup_ubuntu_server_ubuntu_16.sh
	source ./constants.sh
fi

#save current dir
setup_dir=$(pwd) &&

info "Installing TeamCity by JetBrains..."

#install oracle jdk 8
source ./Dependencies/oracle_jdk8.sh &&

#install TeamCity
sudo wget --progress=bar:force https://download.jetbrains.com/teamcity/TeamCity-10.0.3.tar.gz || die "Unable to download TeamCity."
tar xfz TeamCity-10.0.3.tar.gz || die "Unable to extract TeamCity package"
sudo rm -rf $teamcity_installation_path
sudo mkdir -p $teamcity_installation_path
sudo mv TeamCity/* $teamcity_installation_path
sudo chmod -R 0644 $teamcity_installation_path
sudo chown -R $dendro_user_name:$dendro_user_group $teamcity_installation_path

info "Setting up TeamCity service...\n"

#save current dir
setup_dir=$(pwd)

#stop current recommender service if present
info "Stopping $teamcity_service_name service..."
sudo systemctl stop $teamcity_service_name

#setup auto-start teamcity service
sudo rm -rf $teamcity_startup_item_file
sudo touch $teamcity_startup_item_file
sudo chmod 0655 $teamcity_startup_item_file

#create pids folder...
sudo mkdir -p $installation_path/service_pids

printf "Teamcity Running Service Command:"
printf "\n"
printf "/bin/sh -c '$teamcity_installation_path/bin/teamcity-server start >> ${teamcity_log_file} 2>&1'"
printf "\n"

#create dendro user
source ./Programs/create_dendro_user.sh

printf "[Unit]
Description=Teamcity server daemon
[Service]
Type=simple
Restart=on-failure
RestartSec=5s
TimeoutStartSec=infinity
User=$dendro_user_name
Group=$dendro_user_group
RuntimeMaxSec=infinity
KillMode=control-group
ExecStart=/bin/sh -c '$teamcity_installation_path/bin/teamcity-server start >> ${teamcity_log_file} 2>&1'
PIDFile=$installation_path/service_pids/${teamcity_service_name}
[Install]
WantedBy=multi-user.target\n" | sudo tee $teamcity_startup_item_file

sudo chmod 0655 $teamcity_startup_item_file
sudo systemctl daemon-reload
sudo systemctl reload
sudo systemctl enable $teamcity_service_name
sudo systemctl start $teamcity_service_name && success "TeamCity running at $dendro_host:8111" || die "Unable to start TeamCity."

#go back to initial dir
cd $setup_dir || die "Unable to return to starting directory during TeamCity Setup."
