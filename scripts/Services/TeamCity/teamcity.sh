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
sudo chmod 0777 $teamcity_startup_item_file

sudo mkdir $teamcity_pids_folder
sudo chown -R $dendro_user_name:$dendro_user_group $teamcity_pids_folder
sudo chmod -R 0755 $teamcity_pids_folder

#parametrize startup and stop scripts

if [[ ! -d $teamcity_installation_path/control_scripts ]]; then
  cp -r ./Services/control_scripts $teamcity_installation_path
fi

sudo truncate $teamcity_startup_script_file -s 0
sudo sed -e "s;%DENDRO_USERNAME%;$dendro_user_name;g" \
				 -e "s;%TEAMCITY_INSTALLATION_PATH%;$teamcity_installation_path;g" \
				 -e "s;%TEAMCITY_LOG_FILE%;$teamcity_log_file;g" \
				 -e "s;%TEAMCITY_PID_FILE%;$teamcity_pid_file;g" \
         -e "s;%TEAMCITY_START_SCRIPT_FILE%;$teamcity_start_script_file;g" \
				 ./Services/TeamCity/control_scripts/start/teamcity.sh | tee $teamcity_startup_script_file

chmod ugo+x $teamcity_startup_script_file

sudo truncate $teamcity_stop_script_file -s 0
sudo sed -e "s;%DENDRO_USERNAME%;$dendro_user_name;g" \
				 -e "s;%TEAMCITY_INSTALLATION_PATH%;$teamcity_installation_path;g" \
				 -e "s;%TEAMCITY_LOG_FILE%;$teamcity_log_file;g" \
				 -e "s;%TEAMCITY_PID_FILE%;$teamcity_pid_file;g" \
				 ./Services/TeamCity/control_scripts/stop/teamcity.sh | tee $teamcity_stop_script_file

chmod ugo+x $teamcity_stop_script_file

#build startup System V script (/etc/init.d)
sudo sed -e "s;%DENDRO_USERNAME%;$dendro_user_name;g" \
				 -e "s;%TEAMCITY_INSTALLATION_PATH%;$teamcity_installation_path;g" \
				 -e "s;%TEAMCITY_SERVICE_NAME%;$teamcity_service_name;g" \
         -e "s;%TEAMCITY_START_SCRIPT_FILE%;$teamcity_start_script_file;g" \
				 -e "s;%TEAMCITY_LOG_FILE%;$teamcity_log_file;g" \
				 -e "s;%TEAMCITY_PID_FILE%;$teamcity_pid_file;g" \
				 ./Services/TeamCity/service_script_templates/teamcity-template.sh | tee $teamcity_startup_item_file

sudo chmod 0755 $teamcity_startup_item_file
sudo update-rc.d $teamcity_service_name enable
sudo $teamcity_startup_item_file start && success "TeamCity service successfully installed." || die "Unable to install TeamCity service."
