#!/usr/bin/env bash

if [ -z ${DIR+x} ]; then
	#running by itself
	source ../constants.sh
else
	#running from dendro_full_setup_ubuntu_server_ubuntu_16.sh
	source ./constants.sh
fi

info "Setting up TeamCity Agent service...\n"

#save current dir
setup_dir=$(pwd)

#stop current teamcity service if present
info "Stopping $teamcity_agent_service_name service..."
sudo systemctl stop $teamcity_agent_service_name

#setup auto-start teamcity service
sudo rm -rf $teamcity_agent_startup_item_file
sudo touch $teamcity_agent_startup_item_file

#create teamcity log file
sudo touch $teamcity_agent_log_file
sudo chmod ugo+r $teamcity_agent_log_file
sudo chown $dendro_user_name:$dendro_user_group $teamcity_agent_log_file
sudo chmod 0755 $teamcity_agent_startup_item_file

#create teamcity pids folder
sudo mkdir -p $teamcity_pids_folder
sudo touch $teamcity_agent_pid_file

sudo chown -R $dendro_user_name:$dendro_user_group $teamcity_pids_folder
sudo chmod -R 0755 $teamcity_pids_folder

#create control_scripts folder
if [[ ! -d $teamcity_control_scripts_path ]]
then
	sudo mkdir -p $teamcity_control_scripts_path
fi

#build startup and stop scripts from templates
sudo sed -e "s;%TEAMCITY_AGENT_INSTALLATION_PATH%;$teamcity_agent_installation_path;g" \
				 -e "s;%TEAMCITY_AGENT_LOG_FILE%;$teamcity_agent_log_file;g" \
				 ./Services/teamcity/control_scripts/teamcity_agent_start_template.sh | sudo tee $teamcity_agent_start_script &&
sudo chmod 0755 $teamcity_agent_start_script || die "Unable to create TeamCity Agent startup script at $teamcity_agent_start_script."

sudo sed -e "s;%TEAMCITY_AGENT_INSTALLATION_PATH%;$teamcity_agent_installation_path;g" \
				 -e "s;%TEAMCITY_AGENT_LOG_FILE%;$teamcity_agent_log_file;g" \
				 ./Services/teamcity/control_scripts/teamcity_agent_stop_template.sh | sudo tee $teamcity_agent_stop_script &&
sudo chmod 0755 $teamcity_agent_stop_script || die "Unable to create TeamCity Agent stop script at $teamcity_agent_stop_script."

#restore ownership of scripts folder to dendro user and set exec permissions
sudo chown -R $dendro_user_name:$dendro_user_group $teamcity_control_scripts_path
sudo chmod -R 0755 $teamcity_control_scripts_path

#build systemd service file that will call the scripts

printf "[Unit]
Description=TeamCity Server Service
[Service]
Type=simple
Restart=always
RestartSec=5s
TimeoutStartSec=infinity
User=$dendro_user_name
Group=$dendro_user_group
RuntimeMaxSec=infinity
KillMode=control-group
ExecStart=$teamcity_agent_start_script
ExecStop=$teamcity_agent_stop_script
PIDFile=$teamcity_agent_pid_file
[Install]
WantedBy=multi-user.target
" | sudo tee $teamcity_agent_startup_item_file

#restore ownership of everything in the TeamCity agent installation dir
sudo chown -R $dendro_user_name:$dendro_user_group $teamcity_agent_installation_path

#set permissions and reload services
sudo chmod 0655 $teamcity_agent_startup_item_file
sudo systemctl daemon-reload
sudo systemctl enable $teamcity_agent_service_name
sudo systemctl start $teamcity_agent_service_name

#go back to initial dir
cd $setup_dir || die "Unable to return to previous directory after installing TeamCity Build Agent."

success "Finished setting up TeamCity Agent service.\n"
