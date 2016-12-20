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

if [[ ! -d $teamcity_installation_path ]]
then
	die "TeamCity is not installed. Install it with \"./install -c\" , then configure it in http://$host:$teamcity_port and then run the Agent setup with \"./install -a\" ."
else
	info "Installing TeamCity Agent..."

	#install teamcity agent
	cd $teamcity_installation_path || die "Unable to cd to TeamCity directory."

	info "Trying to fetch BuildAgent ZIP File from TeamCity server."

	try_n_times_to_get_url \
		90 \
		"http://$host:$teamcity_port/update/buildAgent.zip" \

	if  [ "$?" -eq "1" ]
	then
		die "Unable to install TeamCity agent. TeamCity did not boot up on time?"
	else
		success "Fetched agent ZIP from the TeamCity Server!"
	fi

	rm -rf buildAgent &&
	mkdir buildAgent &&
	mv buildAgent.zip buildAgent &&
	cd buildAgent || die "Unable to cd to TeamCity BuildAgent directory."
	unzip buildAgent.zip &&
	chown -R $dendro_user_name:$dendro_user_group ../buildAgent &&
	cp conf/buildAgent.dist.properties conf/buildAgent.properties || die "Unable to copy default configuration file for TeamCity Build Agent."

	replace_text_in_file conf/buildAgent.properties \
		'serverUrl=http://localhost:8111/' \
		"serverUrl=http://localhost:$teamcity_port/" \
		'teamcity_patch_dendro_build_server' &&

	patch_file conf/buildAgent.properties \
		'name=' \
		"name=teamcity_patch_dendro_build_server_agent" \
		'teamcity_patch_dendro_build_server_agent_name' || die "Unable to patch the configuration file for TeamCity Build Agent."

	chmod u+x bin/*.sh || die "Unable to set permissions on the TeamCity Scripts."
	cd - || die "Unable to return to previous directory during TeamCity Setup."

	#teamcity agent bootup service

	sudo mkdir $teamcity_pids_folder
	sudo chown -R $dendro_user_name $teamcity_pids_folder
	sudo chmod -R 0755 $teamcity_pids_folder

	sudo chmod 0777 $teamcity_agent_startup_item_file &&
	sudo sed -e "s;%DENDRO_USERNAME%;$dendro_user_name;g" \
					 -e "s;%TEAMCITY_AGENT_INSTALLATION_PATH%;$teamcity_agent_installation_path;g" \
					 -e "s;%TEAMCITY_AGENT_SERVICE_NAME%;$teamcity_agent_service_name;g" \
					 -e "s;%TEAMCITY_AGENT_STARTUP_ITEM_FILE%;$teamcity_agent_startup_item_file;g" \
					 -e "s;%TEAMCITY_AGENT_LOG_FILE%;$teamcity_agent_log_file;g" \
					 ./Services/TeamCity/teamcity-agent-template.sh | tee $teamcity_agent_startup_item_file &&

	sudo chmod 0755 $teamcity_agent_startup_item_file || die "Unable to configure TeamCity startup service."

	sudo update-rc.d $teamcity_agent_service_name enable

	#enable auto-start on process exit
	patch_file /etc/inittab \
		"" \
		"ta:2345:respawn:/bin/sh $teamcity_agent_startup_item_file start"
		"auto_respawn_teamcity_agent"

	sudo $teamcity_agent_startup_item_file start && success "TeamCity Agent service successfully installed." || die "Unable to install TeamCity Agent service."
fi

#go back to initial dir
cd $setup_dir || die "Unable to return to starting directory during TeamCity Setup."
