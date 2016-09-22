#!/usr/bin/env bash

#save current directory
starting_dir=$(pwd)

#cd to the directory of this script
#from http://www.ostricher.com/2014/10/the-right-way-to-get-the-directory-of-a-bash-script/

cd_to_current_dir () {
	DIR="$(get_script_dir)"
	printf "${Cyan}[INFO]${Color_Off} CD'ing to ${DIR}\n"
	cd "${DIR}"
}

cd_to_current_dir
source ./constants.sh

#save current working directory
	setup_dir=$(pwd)
	printf "${Cyan}[INFO]${Color_Off} Setup running at : ${setup_dir}\n"


#reload all services to start dendro and dendro recommender

	#dendro
	printf "${Yellow}[INFO]${Color_Off} Stopping Dendro service ${dendro_service_name}...\n"
	sudo systemctl stop $dendro_service_name
	printf "${Green}[OK]${Color_Off} Stopped Dendro service ${dendro_service_name}\n"

	printf "${Yellow}[INFO]${Color_Off} Disabling Dendro service ${dendro_service_name}...\n"
	sudo systemctl disable $dendro_service_name
	printf "${Green}[OK]${Color_Off} Disabled Dendro service ${dendro_service_name}.\n"

	printf "${Yellow}[INFO]${Color_Off} Deleting Dendro service file at  ${dendro_startup_item_file}...\n"
	sudo rm -rf ${dendro_startup_item_file}
	printf "${Green}[INFO]${Color_Off} Deleted Dendro service file at  ${dendro_startup_item_file}...\n"

	#dendro recommender
	printf "${Yellow}[INFO]${Color_Off} Stopping Dendro Recommender service ${dendro_recommender_service_name}...\n"
	sudo systemctl stop $dendro_recommender_service_name
	printf "${Green}[OK]${Color_Off} Stopped Dendro Recommender service ${dendro_recommender_service_name}.\n"
	
	printf "${Yellow}[INFO]${Color_Off} Disabling Dendro Recommender service ${dendro_recommender_service_name}...\n"
	sudo systemctl disable $dendro_recommender_service_name
	printf "${Green}[OK]${Color_Off} Disabled Dendro Recommender service ${dendro_recommender_service_name}.\n"
	
	printf "${Yellow}[INFO]${Color_Off} Deleting Dendro Recommender service file at  ${dendro_recommender_startup_item_file}...\n"
	sudo rm -rf ${dendro_recommender_startup_item_file}
	printf "${Green}[OK]${Color_Off} Deleted Dendro Recommender service file at  ${dendro_recommender_startup_item_file}...\n"
	
#delete installations
printf "${Yellow}[INFO]${Color_Off} Deleting Dendro installation folder at the ${dendro_service_name} folder...\n"
sudo rm -rf $dendro_installation_path
printf "${Green}[OK]${Color_Off} Deleting Dendro Recommender installation folder at the ${dendro_service_name} folder...\n"

printf "${Yellow}[INFO]${Color_Off} Deleting Dendro Recommender installation folder at the ${dendro_service_name} folder...\n"
sudo rm -rf $dendro_recommender_installation_path
printf "${Green}[OK]${Color_Off} Deleted Dendro Recommender installation folder at the ${dendro_service_name} folder.\n"
	
#delete temp downloads folder
	printf "${Yellow}[INFO]${Color_Off} Deleting temporary folder for downloads at : ${setup_dir}...\n"
	sudo mkdir -p $temp_downloads_folder
	printf "${Green}[OK]${Color_Off} Deleted temporary folder for downloads at : ${setup_dir}.\n"

#check services are up
	source ./Checks/check_services_status.sh

#go back to whatever was the directory at the start of this script
	cd $starting_dir






