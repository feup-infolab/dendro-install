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
	printf "${Cyan}[INFO]${Color_Off} CD'ing to ${DIR}\n"
	cd "${DIR}"	
}

add_line_to_file_if_not_present () {
	LINE=$1
	FILE=$2
	sudo grep -q "$LINE" "$FILE" || sudo echo "$LINE" >> "$FILE"
}


#see if we are supposed to install dependencies or just refresh code from Dendro repositories
# code from http://stackoverflow.com/questions/7069682/how-to-get-arguments-with-flags-in-bash-script

#When you want getopts to expect an argument for an option, just place a : (colon) after the proper option flag. If you want -A to expect an argument (i.e. to become -A SOMETHING) just do: getopts fA:x VARNAME
# http://wiki.bash-hackers.org/howto/getopts_tutorial

refresh_code_only="false"

while getopts 'r' flag; do
  case $flag in
    r) 
		refresh_code_only="true"
		;;
    *) 
		error "Unexpected option ${flag}" 
		;;
  esac
done

cd_to_current_dir
source ./constants.sh

#apply pre-installation fixes such as DNS fixes (thank you bugged Ubuntu distros)
info "Applying pre-installation fixes..."
source ./Fixes/fix_dns.sh

#fix any unfinished installations
	info "Preparing setup..."
	sudo dpkg --configure -a
	sudo apt-get -qq update

#save current working directory
	setup_dir=$(pwd)
	info "Setup running at : ${setup_dir}"

#create temp downloads folder
	info "Creating temporary folder for downloads at : ${setup_dir}"
	sudo mkdir -p $temp_downloads_folder

	#install dependencies
	if [[ "${refresh_code_only}" == "true" ]]
	then
		warning "Bypassing dependency installation"
	else
		warning "Installing dependencies"
		
		source ./Dependencies/misc.sh
		#source ./Dependencies/node.sh #not needed anymore, moved to misc.sh as Node is now installed via apt-get
		
		#install virtuoso
		source ./Dependencies/virtuoso.sh
		source ./Services/virtuoso.sh
		source ./SQLCommands/grant_commands.sh
		source ./Checks/check_services_status.sh

		source ./Programs/create_dendro_user.sh
		source ./Dependencies/play_framework.sh
		source ./Dependencies/mysql.sh
		source ./Dependencies/mongodb.sh
		source ./Services/mongodb.sh

		source ./Dependencies/elasticsearch.sh
		source ./Services/elasticsearch.sh
	fi

#generate configuration files for both solutions
	source ./Programs/generate_configuration_files.sh

#create shared mysql database
	source ./Programs/create_database.sh

#install dendro
	source ./Programs/Dendro/create_log.sh
	source ./Programs/Dendro/checkout.sh


	#place configuration file in dendro's deployment configs folder
	wd=$(pwd)
	warning "Copying configuration file ${wd}/Programs/generated_configurations/deployment_configs.json to ${dendro_installation_path}/conf"
	sudo cp $(pwd)/Programs/generated_configurations/deployment_configs.json $dendro_installation_path/conf

	#stage dendro service
	source ./Services/dendro.sh #??

#install dendro recommender
	source ./Programs/DendroRecommender/create_log.sh
	source ./Programs/DendroRecommender/checkout.sh
	
	#place configuration file in dendro recommender's config folder
	sudo cp ./Programs/generated_configurations/application.conf $dendro_recommender_install_path/conf
	
	#stage dendro recommender service
	source ./Services/recommender.sh #??

#cleanup 
	sudo apt-get -qq autoremove
	sudo rm -rf Programs/generated_configurations

#regenerate variables
	sudo locale-gen --purge en_US en_US.UTF-8 hu_HU hu_HU.UTF-8
	sudo dpkg-reconfigure -f noninteractive locales

#check services are up
	source ./Checks/check_services_status.sh

#reload all services to start dendro and dendro recommender
	sudo systemctl reload

#go back to whatever was the directory at the start of this script
	cd $starting_dir






