#!/usr/bin/env bash

#save current directory
starting_dir=$(pwd)

#cd to the directory of this script
#from http://www.ostricher.com/2014/10/the-right-way-to-get-the-directory-of-a-bash-script/

get_script_dir  () {
	SOURCE="${BASH_SOURCE[0]}"
	# While $SOURCE is a symlink, resolve it
	while [ -h "$SOURCE" ]; do
		DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
		SOURCE="$( readlink "$SOURCE" )"
		# If $SOURCE was a relative symlink (so no "/" as prefix, need to resolve it relative to the symlink base directory
		[[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE"
	done
	DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
	echo $DIR
}

cd_to_current_dir () {
	DIR="$(get_script_dir)"
	echo "Changing ing to ${DIR}"
	cd "${DIR}" || die "Folder ${DIR} does not exist."
}

add_line_to_file_if_not_present () {
	LINE=$1
	FILE=$2
	sudo sh -c "grep -q -F \"$LINE\" \"$FILE\" || sudo echo \"$LINE\" >> \"$FILE\""
}

copy_config_files() {
	#place configuration file in dendro's deployment configs folder
	warning "Copying configuration file $running_dir/Programs/generated_configurations/deployment_configs.json to $dendro_installation_path/conf"
	sudo cp "$running_dir/Programs/generated_configurations/deployment_configs.json" "$dendro_installation_path/conf"
}

installShibbolethDependencies()
{

	generateNewServiceProviderFiles()
	{
		parent_of_shibboleth_authentication_key_file=$1
		parent_of_shibboleth_authentication_cert_file=$2

		warning "Will generate Shibboleth service provider files!"
        mkdir -p $parent_of_shibboleth_authentication_key_file || die "could not create folder $parent_of_shibboleth_authentication_key_file"
        mkdir -p $parent_of_shibboleth_authentication_cert_file || die "could not create folder $parent_of_shibboleth_authentication_cert_file"
        openssl req -x509 \
        	-newkey rsa:4096 \
        	-keyout $shibboleth_authentication_key_path \
        	-out $shibboleth_authentication_cert_path \
        	-nodes \
        	-days 900 \
        	-subj "/C=$openssl_country/ST=$openssl_state/L=$openssl_location/O=$openssl_organization/OU=$openssl_organizational_unit/CN=$openssl_common_name" || die "could not create service provider files!"
        success "Shibboleth service provider files generated!"
	}

	checkIfServiceProviderShibbolethFilesExist()
	{
		parent_of_shibboleth_authentication_key_file=${shibboleth_authentication_key_path%/*}
	    parent_of_shibboleth_authentication_cert_file=${shibboleth_authentication_cert_path%/*}

	    info "parent_of_shibboleth_authentication_key: $parent_of_shibboleth_authentication_key_file"
	    info "parent_of_shibboleth_authentication_cert: $parent_of_shibboleth_authentication_cert_file"

	    #if key.pem and cert.pem files are missing, the script should generate them
	    #However the idp_cert.pem file is dependent on the Shibboleth IDP, so this file must be manually retrieved and set by the system admin
	    if [ ! -f $shibboleth_authentication_key_path -o  ! -f $shibboleth_authentication_cert_path ]; then
	        warning "Shibboleth service provider files not found!"
	        while true; do
	            read -p "Will generate new Shibboleth service provider files!!! PLEASE PROVIDE the updated xml(with the updated $shibboleth_authentication_cert_path) file to the Identity Provider! Type 'yes' to continue OR 'no' to abort : " yn
	            case $yn in
	                [Yy]* ) generateNewServiceProviderFiles "$parent_of_shibboleth_authentication_key_file" "$parent_of_shibboleth_authentication_cert_file"; break;;
	                [Nn]* ) die "Will NOT continue Shibboleth installation!"; break;;
	                * ) echo "Please answer yes or no.";;
	            esac
	        done
	    else
	        success "Shibboleth service provider files already exist!"
	    fi
	}

	checkIfIdentityProviderFilesExist()
	{
		if [ ! -f $shibboleth_authentication_idp_cert_path ]; then
        	error "Shibboleth identity provider files not found!"
	        die "Please upload $shibboleth_authentication_idp_cert_path"
	    else
	        success "Shibboleth identity provider files already exist!"
	    fi
	}

	setup()
	{
		checkIfIdentityProviderFilesExist
		checkIfServiceProviderShibbolethFilesExist
	    success "$shibboleth_authentication_idp_cert_path set!"
	    success "$shibboleth_authentication_key_path set!"
	    success "$shibboleth_authentication_cert_path set!"
	}

	checkIfAdminWantsToInstallShibbolethDependencies()
	{
		#while true; do
        #    read -p "Do you want to install Shibboleth dependencies ? Type 'yes' OR 'no' : " yn
        #    case $yn in
        #        [Yy]* ) setup; break;;
        #        [Nn]* ) info "Will not install Shibboleth dependencies!"; break;;
        #        * ) echo "Please answer yes or no.";;
        #    esac
        #done

        #shibboleth_authentication_enabled
        if [ "$shibboleth_authentication_enabled" = "true" ]; then
  			info "Will install Shibboleth dependencies!"
  			setup
	    else
	        info "Will not install Shibboleth dependencies!"
	    fi
	}

	checkIfAdminWantsToInstallShibbolethDependencies
}

#see if we are supposed to install dependencies or just refresh code from Dendro repositories
# code from http://stackoverflow.com/questions/7069682/how-to-get-arguments-with-flags-in-bash-script

#When you want getopts to expect an argument for an option, just place a : (colon) after the proper option flag. If you want -A to expect an argument (i.e. to become -A SOMETHING) just do: getopts fA:x VARNAME
# http://wiki.bash-hackers.org/howto/getopts_tutorial

refresh_code_only="false"
set_dev_mode="false"

while getopts 'agfgtjdursb:' flag; do
  case $flag in
	a)
     	install_teamcity_agent="true"
      	;;
	g)
     	regenerate_configs="true"
      	;;
	c)
     	install_teamcity="true"
      	;;
    t)
     	run_tests="true"
      	;;
    r)
		refresh_code_only="true"
	  	;;
	d)
		set_dev_mode="true"
	  	;;
	u)
		unset_dev_mode="true"
		;;
	j)
		install_jenkins="true"
		;;
    b)
   	 	dendro_branch=$OPTARG
    	;;
    s)
   	 	setup_service_dendro_service_only="true"
    	;;
    *)
		error "Unexpected option $flag"
		;;
  esac
done

cd_to_current_dir
source ./constants.sh
source ./secrets.sh

copy_config_files() {
	local starting_dir
	starting_dir=$(get_script_dir)

	info "Starting dir when copying config files: $starting_dir"
	#place configuration file in dendro's deployment configs folder
	warning "Copying configuration file $starting_dir/Programs/generated_configurations/deployment_configs.json to ${dendro_installation_path}/conf"

	if [ "${regenerate_configs}" == "true" ];
	then
		if [ -f "$starting_dir/Programs/generated_configurations/deployment_configs.json.swp" ]
		then 
			rm "$starting_dir/Programs/generated_configurations/deployment_configs.json.swp"
		fi

		cat "$starting_dir/Programs/generated_configurations/deployment_configs.json"
	fi

	sudo cp "$starting_dir/Programs/generated_configurations/deployment_configs.json" "$dendro_installation_path/conf"
	sudo chown -R $dendro_user_name:$dendro_user_group $installation_path
	sudo chmod -R 0755 $installation_path

	if [ "$regenerate_configs" == "true" ];
	then
		success "All finished, new files copied."
		exit 0
	fi
}

installShibbolethDependencies

if [ "${regenerate_configs}" == "true" ];
then
	warning "Regenerating configurations only"
	cd_to_current_dir
	#generate configuration files for both solutions
	source ./Programs/generate_configuration_files.sh
	copy_config_files
fi

if [ "${setup_service_dendro_service_only}" == "true" ]
then
	info "Rebuilding the dendro service configuration for service $dendro_service_name..."
	source ./Services/dendro.sh
	success "Dendro service $dendro_service_name recreated and booting up. Setup will exit now."
	exit 0
fi

#apply pre-installation fixes such as DNS fixes (thank you bugged Vagrant Ubuntu boxes)
info "Applying pre-installation fixes..."
source ./Fixes/fix_dns.sh
#source ./Fixes/fix_locales.sh

#fix any unfinished installations
info "Preparing setup..."
sudo dpkg --configure -a
sudo apt-get -qq update

#create dendro user is necessary
warning "Creating $dendro_user_name if necessary and adding to $dendro_user_group if necessary"
source ./Programs/create_dendro_user.sh

#install or load nvm
warning "Starting NVM setup in order to install node version $node_version..."
sudo chmod +x "$setup_dir/Checks/load_nvm.sh"

#install nvm as dendro_user
warning "Installing NVM as $dendro_user_name in order to install node version $node_version..."
sudo su - "$dendro_user_name" -c "$setup_dir/Checks/load_nvm.sh $node_version" || die "Unable to install/load NVM as $dendro_user_name"

#install nvm as current user
warning "Installing NVM as $(whoami) in order to install node version $node_version..."
./Checks/load_nvm.sh $node_version || die "Unable to install/load NVM as $dendro_user_name" || die "Unable to install/load NVM as $(whoami)"

#install nvm as ubuntu (vm user).
#This can fail without dying because not always we have a 'ubuntu' user
sudo su - "ubuntu" -c "$setup_dir/Checks/load_nvm.sh $node_version"

if [ "${set_dev_mode}" != "true" ] && [ "${unset_dev_mode}" != "true" ] && [ "$install_jenkins" != "true" ] && [ "$install_teamcity" != "true" ] && [ "$install_teamcity_agent" != "true" ]
then
	info "Running the Dendro User Setup."

	#save current working directory
		setup_dir=$(pwd)
		info "Setup running at : ${setup_dir}"

	#create temp downloads folder
		info "Creating temporary folder for downloads at : ${setup_dir}"
		sudo mkdir -p $temp_downloads_folder

		#install dependencies
		if [ "${refresh_code_only}" == "true" ]; then
			warning "Bypassing dependency installation"
			source ./SQLCommands/grant_commands.sh
		else
			warning "Installing dependencies"
			source ./Dependencies/misc.sh

			# Install MongoDB
			source ./Dependencies/mongodb.sh

			#install virtuoso
			if [[ "${install_virtuoso_from_source}" == "true" ]]
			then
				info "Installing OpenLink Virtuoso Database from source"
				source ./Dependencies/virtuoso_from_source.sh
				source ./Services/virtuoso.sh
			else
				info "Installing OpenLink Virtuoso Database from .deb GitHub package @feup-infolab/virtuoso7-debs."
				source ./Dependencies/virtuoso_from_deb.sh
				source ./Services/virtuoso.sh
			fi


			info "Waiting for virtuoso service to start."
			wait_for_server_to_boot_on_port "127.0.0.1" "8890"
			wait_for_server_to_boot_on_port "127.0.0.1" "1111"

			info "Installing base ontologies in virtuoso..."
			source ./SQLCommands/grant_commands.sh

			# Install MongoDB
			source ./Dependencies/mongodb.sh
			#source ./Services/mongodb.sh

			#source ./Dependencies/drawing_to_text.sh #TODO this crashes still with GCC 5.8+. Commenting
			source ./Dependencies/Redis/setup_redis_instances.sh
			

			if [[ "$dendro_recommender_active" == "true" ]]
			then
				source ./Dependencies/play_framework.sh
			fi

			source ./Dependencies/mysql.sh

			source ./Dependencies/elasticsearch.sh
			source ./Services/elasticsearch.sh
			
			#source ./Checks/check_services_status.sh
		fi

		#generate configuration files for both solutions
		source ./Programs/generate_configuration_files.sh

	#create shared mysql database
		source ./Programs/create_database.sh

	#install dendro
		source ./Programs/Dendro/create_log.sh
		source ./Programs/Dendro/checkout.sh
		sudo su $dendro_user_name ./Programs/Dendro/install.sh || die "Unable to install Dendro."

		copy_config_files

		#stage dendro service
		source ./Services/dendro.sh #??

	#install dendro recommender
		if [[ "$dendro_recommender_active" == "true" ]]
		then
			source ./Programs/DendroRecommender/create_log.sh
			source ./Programs/DendroRecommender/checkout.sh

			#place configuration file in dendro recommender's config folder
			sudo cp "./Programs/generated_configurations/application.conf" "$dendro_recommender_install_path/conf"

			#stage dendro recommender service
			source ./Services/recommender.sh #??
		fi

	#cleanup
		sudo apt-get -qq autoremove
		sudo rm -rf Programs/generated_configurations

	#regenerate variables
		sudo locale-gen --purge en_US en_US.UTF-8 hu_HU hu_HU.UTF-8
		sudo dpkg-reconfigure -f noninteractive locales

	#check services are up
		#source ./Checks/check_services_status.sh

	#reload all services to start dendro and dendro recommender
		sudo systemctl reload
		info "This Dendro instance has been installed in User mode."
		info "NOTE: To enable Development mode, re-run the installer with the -d flag. Example: ./install.sh -d"

		if [[ "$JENKINS_BUILD" == '1' && "$tests_branch" != "" ]]
		then
			echo "[JENKINS] JENKINS build detected. Setting dendro branch as $tests_branch"
			dendro_branch=$tests_branch
		elif [[ "$dendro_branch" != "" ]]; then
			info "Development branch $dendro_branch now active."
		fi
else
		if [[ "${set_dev_mode}" == "true" ]]
		then
			info "Running the Dendro Developer Setup."
			info "NOTE: To disable Development mode, use the -u flag. Example: ./install.sh -u"
			source ./Fixes/set_dev_mode.sh
			source ./SQLCommands/grant_commands.sh
			info "This Dendro instance has been set to Development mode."
			warning "DO NOT use this in a production environment. Having all your databases accepting remote connections can represent a serious security risk."
		fi
		if [[ "${unset_dev_mode}" == "true" ]]
		then
			info "NOTE: To enable Development mode, use the -d flag. Example: ./install.sh -d"
			source ./Fixes/unset_dev_mode.sh
			source ./SQLCommands/grant_commands.sh
			info "This Dendro instance has been reverted to User mode."
		fi
		if [[ "$install_jenkins" == "true" ]]
		then
			info "Running Jenkins Setup."
			source ./Programs/Jenkins/install_jenkins.sh
		fi
		if [[ "$install_teamcity" == "true" ]]
		then
			info "Running TeamCity Setup."
			source ./Programs/TeamCity/install_teamcity.sh
			source ./Services/teamcity/teamcity.sh
		elif [[ "$install_teamcity_agent" == "true" ]]
		then
			info "Running TeamCity Agent Setup."
			source ./Programs/TeamCity/install_teamcity_agent.sh
			source ./Services/teamcity/teamcity_agent.sh
		fi
fi

#go back to whatever was the directory at the start of this script
cd "${starting_dir}" || warning "Unable to go back to the starting directory."

#install vm tools to prevent crashes
sudo apt-get install -y open-vm-tools

#all ok.
success "Setup operations complete."

if [ "$install_jenkins" == "true" ]
then
	info "Visit http://${host}:${jenkins_port} for the Jenkins web interface."
elif [ "$install_teamcity" == "true" ]
then
	info "TeamCity running at http://$host:$teamcity_port"
elif [ "$install_teamcity_agent" == "true" ]
then
	info "TeamCity agent installed."
	info "TeamCity running at http://$host:$teamcity_port"
else
	info "Visit ${dendro_base_uri} for the Dendro web interface."
	info "Visit http://${dendro_recommender_host}:${dendro_recommender_port} for the Dendro Recommender web interface."
	if [[ "$dendro_branch" != "" ]]; then
		info "Development branch $dendro_branch now active."
	fi
fi
