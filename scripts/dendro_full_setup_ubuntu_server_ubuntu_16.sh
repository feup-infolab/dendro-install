#!/usr/bin/env bash

#save current directory
starting_dir=$(pwd)

#cd to the directory of this script
#from http://www.ostricher.com/2014/10/the-right-way-to-get-the-directory-of-a-bash-script/

get_script_dir () {
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

cd_to_current_dir() {
	DIR="$(get_script_dir)"
	echo "[INFO] CD'ing to ${DIR}"
	cd "${DIR}"	
}

cd_to_current_dir
source ./constants.sh

#fix any unfinished installations
	sudo dpkg --configure -a
	sudo apt-get -qq update

#save current working directory
	setup_dir=$(pwd)
	echo "[INFO] Setup running at : ${setup_dir}"

#create temp downloads folder
	echo "[INFO] Creating temporary folder for downloads at : ${setup_dir}"
	sudo mkdir -p $temp_downloads_folder

#install dependencies
	source ./Dependencies/misc.sh #OK
	source ./Dependencies/node.sh #OK

	#install virtuoso
	source ./Dependencies/virtuoso.sh #OK
	source ./Services/virtuoso.sh #OK
	source ./SQLCommands/grant_commands.sh #OK
	source ./Checks/check_services_status.sh

	source ./Dependencies/svn_18.sh #OK
	source ./Programs/create_dendro_user.sh #OK
	source ./Dependencies/play_framework.sh #OK

	source ./Dependencies/mysql.sh #OK
	source ./Dependencies/mongodb.sh #OK
	source ./Services/mongodb.sh #OK

	source ./Dependencies/elasticsearch.sh #OK
	source ./Services/elasticsearch.sh #OK


#generate configuration files for both solutions
	source ./Programs/generate_configuration_files.sh

#create shared mysql database
	source ./Programs/create_database.sh #OK

#install dendro
	source ./Programs/Dendro/create_log.sh #OK
	source ./Programs/Dendro/checkout.sh #OK

	#place configuration file in dendro's deployment configs folder
	cp $(pwd)/Programs/generated_configurations/deployment_configs.json $dendro_installation_path/deployment

	#stage dendro service
	source ./Services/dendro.sh #??

#install dendro recommender
	source ./Programs/DendroRecommender/create_log.sh #OK
	source ./Programs/DendroRecommender/checkout.sh #ok
	
	#place configuration file in dendro recommender's config folder
	cp ./Programs/generated_configurations/application.conf $dendro_recommender_install_path/conf
	
	#stage dendro recommender service
	source ./Services/recommender.sh #??

#cleanup 
	sudo apt-get -qq autoremove
	rm -rf Programs/generated_configurations

#regenerate variables
	sudo locale-gen --purge en_US en_US.UTF-8 hu_HU hu_HU.UTF-8
	sudo dpkg-reconfigure -f noninteractive locales

#check services are up
	source ./Checks/check_services_status.sh

#reload all services to start dendro and dendro recommender
	sudo systemctl reload

#go back to whatever was the directory at the start of this script
	cd $starting_dir






