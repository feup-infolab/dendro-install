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

	sudo apt-get install unzip
	sudo rm -rf $teamcity_agent_installation_path &&
	sudo mkdir -p $teamcity_agent_installation_path &&
	sudo unzip buildAgent.zip -d $teamcity_agent_installation_path &&
	sudo chown -R $dendro_user_name:$dendro_user_group $teamcity_agent_installation_path
	sudo rm -f buildAgent.zip || die "Unable to cd to TeamCity BuildAgent directory."

	cd - || die "Unable to cd to initial directory after fetching Teamcity Agent ZIP."

#configure teamcity agent installation

	sudo cp $teamcity_agent_installation_path/conf/buildAgent.dist.properties \
		$teamcity_agent_installation_path/conf/buildAgent.properties \
		|| die "Unable to copy default configuration file for TeamCity Build Agent."

	replace_text_in_file $teamcity_agent_installation_path/conf/buildAgent.properties \
		"serverUrl=http://localhost:8111/" \
		"serverUrl=http://$host:$teamcity_port/" \
		"teamcity_patch_dendro_build_server" &&

	patch_file $teamcity_agent_installation_path/conf/buildAgent.properties \
		'name=' \
		"name=teamcity_patch_dendro_build_server_agent" \
		'teamcity_patch_dendro_build_server_agent_name' || die "Unable to patch the configuration file for TeamCity Build Agent."

	chmod 0755 $teamcity_agent_installation_path/bin/*.sh || die "Unable to set permissions on the TeamCity Scripts."
	cd - || die "Unable to return to previous directory during TeamCity Setup."
fi

#go back to initial dir
cd $setup_dir || die "Unable to return to starting directory during TeamCity Setup."
