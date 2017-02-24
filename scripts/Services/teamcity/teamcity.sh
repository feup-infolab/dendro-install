#!/usr/bin/env bash

if [ -z ${DIR+x} ]; then
	#running by itself
	source ../constants.sh
else
	#running from dendro_full_setup_ubuntu_server_ubuntu_16.sh
	source ./constants.sh
fi

info "Setting up TeamCity service...\n"

#save current dir
setup_dir=$(pwd)

#stop current teamcity service if present
info "Stopping $teamcity_service_name service..."
sudo systemctl stop $teamcity_service_name > /dev/null

#setup auto-start teamcity service
sudo rm -rf $teamcity_startup_item_file
sudo touch $teamcity_startup_item_file
sudo chmod 0755 $teamcity_startup_item_file

#create teamcity log file
sudo touch $teamcity_log_file
sudo chmod ugo+r $teamcity_log_file
sudo chown $dendro_user_name:$dendro_user_group $teamcity_log_file

#create teamcity pids folder

if [[ -d $teamcity_pids_folder ]]
then
	sudo mkdir -p $teamcity_pids_folder
	sudo chown -R $dendro_user_name:$dendro_user_group $teamcity_pids_folder
	sudo chmod -R 0655 $teamcity_pids_folder
fi

# #create control_scripts folder
# if [[ -d $teamcity_control_scripts_path ]]
# then
# 	sudo mkdir -p $teamcity_control_scripts_path
# fi
#
# #build startup and stop scripts from templates
# sudo sed -e "s;%TEAMCITY_INSTALLATION_PATH%;$teamcity_installation_path;g" \
# 				 -e "s;%TEAMCITY_LOG_FILE%;$teamcity_log_file;g" \
# 				 ./Services/teamcity/control_scripts/teamcity_start_template.sh | sudo tee $teamcity_start_script &&
# sudo chmod 0755 $teamcity_start_script || die "Unable to create TeamCity startup script at $teamcity_start_script."
#
# sudo sed -e "s;%TEAMCITY_INSTALLATION_PATH%;$teamcity_installation_path;g" \
# 				 -e "s;%TEAMCITY_LOG_FILE%;$teamcity_log_file;g" \
# 				 ./Services/teamcity/control_scripts/teamcity_stop_template.sh | sudo tee $teamcity_stop_script &&
# sudo chmod 0755 $teamcity_stop_script || die "Unable to create TeamCity stop script at $teamcity_stop_script."
#
# #restore ownership of scripts folder to dendro user and set exec permissions
# sudo chown -R $dendro_user_name:$dendro_user_group $teamcity_control_scripts_path
# sudo chmod -R 0755 $teamcity_control_scripts_path

sudo chown -R $dendro_user_name:$dendro_user_group $teamcity_installation_path
sudo chmod -R 0755 $teamcity_installation_path

#build systemd service file that will call the scripts

printf "[Unit]
Description=TeamCity Server Service
After=network.target
[Service]
Type=forking
User=$dendro_user_name
Group=$dendro_user_group
ExecStart=$teamcity_installation_path/bin/teamcity-server.sh start
ExecStop=$teamcity_installation_path/bin/teamcity-server.sh stop
PIDFile=$teamcity_pid_file
[Install]
WantedBy=multi-user.target
" | sudo tee $teamcity_startup_item_file

#restore ownership of everything in the TeamCity installation dir
sudo chown -R $dendro_user_name:$dendro_user_group $teamcity_installation_path

#set permissions and reload services
sudo chmod 0655 $teamcity_startup_item_file
sudo systemctl daemon-reload
sudo systemctl enable $teamcity_service_name
sudo systemctl start $teamcity_service_name

#go back to initial dir
cd $setup_dir || die "Unable to return to previous directory after installing TeamCity Server."

success "Finished setting up TeamCity Server service.\n"
