#!/usr/bin/env bash

#save current directory
starting_dir=$(pwd)

#cd to the directory of this script
#from http://www.ostricher.com/2014/10/the-right-way-to-get-the-directory-of-a-bash-script/

cd_to_current_dir  {
	DIR="$(get_script_dir)"
	info "CD'ing to ${DIR}"
	cd "${DIR}"
}

cd_to_current_dir
source ./constants.sh

#save current working directory
	setup_dir=$(pwd)
	info "Setup running at : ${setup_dir}"


#reload all services to start dendro and dendro recommender

	#dendro
	warning "Stopping Dendro service ${dendro_service_name}..."
	sudo systemctl stop $dendro_service_name > /dev/null
	success "Stopped Dendro service ${dendro_service_name}"

	warning "Disabling Dendro service ${dendro_service_name}..."
	sudo systemctl disable $dendro_service_name
	success "Disabled Dendro service ${dendro_service_name}."

	warning "Deleting Dendro service file at  ${dendro_startup_item_file}..."
	sudo rm -rf ${dendro_startup_item_file}
	success "Deleted Dendro service file at  ${dendro_startup_item_file}..."

	#dendro recommender
	warning "Stopping Dendro Recommender service ${dendro_recommender_service_name}..."
	sudo systemctl stop $dendro_recommender_service_name > /dev/null
	success "Stopped Dendro Recommender service ${dendro_recommender_service_name}."

	warning "Disabling Dendro Recommender service ${dendro_recommender_service_name}..."
	sudo systemctl disable $dendro_recommender_service_name
	success "Disabled Dendro Recommender service ${dendro_recommender_service_name}."

	warning "Deleting Dendro Recommender service file at  ${dendro_recommender_startup_item_file}..."
	sudo rm -rf ${dendro_recommender_startup_item_file}
	success "Deleted Dendro Recommender service file at  ${dendro_recommender_startup_item_file}..."

	#delete installations
	warning "Deleting Dendro installation folder at the ${dendro_service_name} folder..."
	sudo rm -rf $dendro_installation_path
	success "Deleting Dendro Recommender installation folder at the ${dendro_service_name} folder..."

	warning "Deleting Dendro Recommender installation folder at the ${dendro_service_name} folder..."
	sudo rm -rf $dendro_recommender_installation_path
	success "Deleted Dendro Recommender installation folder at the ${dendro_service_name} folder."

	#delete temp downloads folder
	warning "Deleting temporary folder for downloads at : ${setup_dir}..."
	sudo mkdir -p $temp_downloads_folder
	success "Deleted temporary folder for downloads at : ${setup_dir}."

#check services are up
	#source ./Checks/check_services_status.sh

#go back to whatever was the directory at the start of this script
	cd $starting_dir
