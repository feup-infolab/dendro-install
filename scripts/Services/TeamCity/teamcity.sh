#!/usr/bin/env bash

if [ -z ${DIR+x} ]; then
	#running by itself
	source ../../constants.sh
else
	#running from dendro_full_setup_ubuntu_server_ubuntu_16.sh
	source ./constants.sh
fi

info "Setting up TeamCity service...\n"

#save current dir
setup_dir=$(pwd)

#setup auto-start teamcity service
sudo rm -rf $teamcity_startup_item_file
sudo touch $teamcity_startup_item_file

#create pids folder...
sudo mkdir -p $installation_path/service_pids

#create teamcity log file
sudo touch $teamcity_log_file
sudo chmod ugo+r $teamcity_log_file
sudo chown $dendro_user_name:$dendro_user_group $teamcity_log_file
sudo chmod 0755 $teamcity_startup_item_file

sudo mkdir $teamcity_pids_folder
sudo chown -R $dendro_user_name:$dendro_user_group $teamcity_pids_folder
sudo chmod -R 0755 $teamcity_pids_folder

#parametrize startup and stop scripts

#clear existing scripts and copy over templates
sudo rm -rf $teamcity_control_scripts_folder
sudo cp -rf ./Services/TeamCity/control_scripts $teamcity_installation_path

if [[ -f $teamcity_start_script_file ]]
then
	sudo truncate $teamcity_start_script_file -s 0
else
	sudo touch $teamcity_start_script_file
fi

sudo sed -e "s;%DENDRO_USERNAME%;$dendro_user_name;g" \
				 -e "s;%TEAMCITY_INSTALLATION_PATH%;$teamcity_installation_path;g" \
				 -e "s;%TEAMCITY_LOG_FILE%;$teamcity_log_file;g" \
				 -e "s;%TEAMCITY_PID_FILE%;$teamcity_pid_file;g" \
         -e "s;%TEAMCITY_START_SCRIPT_FILE%;$teamcity_start_script_file;g" \
				 ./Services/TeamCity/control_scripts/start/start_teamcity.sh | sudo tee $teamcity_start_script_file &&
sudo chmod 0755 $teamcity_start_script_file || die "Unable to create TeamCity startup script."

if [[ -f $teamcity_stop_script_file ]]
then
	sudo truncate $teamcity_stop_script_file -s 0
else
	sudo touch $teamcity_stop_script_file
fi

sudo sed -e "s;%DENDRO_USERNAME%;$dendro_user_name;g" \
				 -e "s;%TEAMCITY_INSTALLATION_PATH%;$teamcity_installation_path;g" \
				 -e "s;%TEAMCITY_LOG_FILE%;$teamcity_log_file;g" \
				 -e "s;%TEAMCITY_PID_FILE%;$teamcity_pid_file;g" \
				 ./Services/TeamCity/control_scripts/stop/stop_teamcity.sh | sudo tee $teamcity_stop_script_file &&
sudo chmod 0755 $teamcity_stop_script_file || die "Unable to create TeamCity stop script."

if [[ -f $teamcity_startup_item_file ]]
then
	sudo truncate $teamcity_startup_item_file -s 0
else
	sudo touch $teamcity_startup_item_file
fi

#build startup System V script (/etc/init.d)
sudo sed -e "s;%DENDRO_USERNAME%;$dendro_user_name;g" \
				 -e "s;%TEAMCITY_INSTALLATION_PATH%;$teamcity_installation_path;g" \
				 -e "s;%TEAMCITY_SERVICE_NAME%;$teamcity_service_name;g" \
         -e "s;%TEAMCITY_START_SCRIPT_FILE%;$teamcity_start_script_file;g" \
				 -e "s;%TEAMCITY_LOG_FILE%;$teamcity_log_file;g" \
				 -e "s;%TEAMCITY_PID_FILE%;$teamcity_pid_file;g" \
				 ./Services/TeamCity/service_script_templates/teamcity-template.sh | sudo tee $teamcity_startup_item_file &&
sudo chmod 0755 $teamcity_startup_item_file || die "Unable to create TeamCity startup item (System V startup script file)."

#restore ownership of the folder to the dendro user
sudo chown -R $dendro_user_name:$dendro_user_group $teamcity_installation_path

sudo update-rc.d $teamcity_service_name enable
sudo $teamcity_startup_item_file start && success "TeamCity service successfully installed." || die "Unable to install TeamCity service."
