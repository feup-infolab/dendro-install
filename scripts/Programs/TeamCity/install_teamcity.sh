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

#create dendro user
source ./Programs/create_dendro_user.sh

#install TeamCity
# sudo wget --progress=bar:force https://download.jetbrains.com/teamcity/TeamCity-10.0.3.tar.gz || die "Unable to download TeamCity."
# tar xfz TeamCity-10.0.3.tar.gz || die "Unable to extract TeamCity package"
# sudo rm -rf $teamcity_installation_path
# sudo mkdir -p $teamcity_installation_path
# sudo mv TeamCity/* $teamcity_installation_path
# sudo chown -R $dendro_user_name $teamcity_installation_path
# sudo chmod -R ug+w $teamcity_installation_path

info "Setting up TeamCity service...\n"

#save current dir
setup_dir=$(pwd)

#stop current recommender service if present
info "Stopping $teamcity_service_name service..."
sudo systemctl stop $teamcity_service_name

#setup auto-start teamcity service
sudo rm -rf $teamcity_startup_item_file
sudo touch $teamcity_startup_item_file
sudo chmod 0755 $teamcity_startup_item_file

#create pids folder...
sudo mkdir -p $installation_path/service_pids

printf "Teamcity Running Service Command:"
printf "\n"
printf "/bin/sh -c '$teamcity_installation_path/bin/teamcity-server.sh run >> ${teamcity_log_file} 2>&1'"
printf "\n"

#create teamcity log file
sudo touch $teamcity_log_file
sudo chmod ugo+r $teamcity_log_file
sudo chown $dendro_user_name $teamcity_log_file

# [Unit]
# Description=Teamcity server daemon
# [Service]
# Type=simple
# Restart=on-failure
# RestartSec=5s
# TimeoutStartSec=infinity
# User=dendro
# Group=dendro
# RuntimeMaxSec=infinity
# KillMode=control-group
# StandardOutput=console
# ExecStart=/TeamCity/bin/teamcity-server.sh start
# PIDFile=/dendro/service_pids/teamcity
# [Install]
# WantedBy=multi-user.target

#sudo systemctl daemon-reload; sudo service teamcity restart; sudo service teamcity status
#sudo vim /etc/systemd/system/teamcity.service
#tail -f /TeamCity/logs/teamcity-server.log

counter=0
n_attempts=10
result=""

until [[ "$result" == "0" || "$counter" == "$n_attempts" ]]
do
	counter=$((counter + 1))
	info "Try number $counter to restart the TeamCity server cleanly..."
	sudo su $dendro_user_name /bin/bash -c "\'$teamcity_installation_path/bin/teamcity-server.sh start\'" &&
	sudo su $dendro_user_name /bin/bash -c "\'$teamcity_installation_path/bin/teamcity-server.sh stop\'"
	result=$?
done

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
StandardOutput=console
ExecStart=/bin/bash -c '$teamcity_installation_path/bin/teamcity-server.sh run >> $teamcity_log_file 2>&1'
PIDFile=$installation_path/service_pids/${teamcity_service_name}
[Install]
WantedBy=multi-user.target\n" | sudo tee $teamcity_startup_item_file

sudo chmod 0744 $teamcity_startup_item_file
sudo systemctl daemon-reload
sudo systemctl enable $teamcity_service_name
sudo systemctl unmask $teamcity_service_name
sudo systemctl restart $teamcity_service_name && success "TeamCity service successfully installed." || die "Unable to install TeamCity service."

#go back to initial dir
cd $setup_dir || die "Unable to return to starting directory during TeamCity Setup."
