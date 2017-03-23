#!/usr/bin/env bash

if [ -z ${DIR+x} ]; then
	#running by itself
	source ../../constants.sh
else
	#running from dendro_full_setup_ubuntu_server_ubuntu_16.sh
	source ./constants.sh
fi

#save current dir
setup_dir=$(pwd)

info "Stopping ${dendro_service_name} service..."
sudo systemctl stop $dendro_service_name > /dev/null

if [[ "${dr_stage1_active}" == "true" ]]
then
	dendro_recommender_interactions_table="${interactions_table_stage1}"
	printf "${Cyan}[INFO]${Color_Off} Stage 1 of recommender is set as active. Interactions table will be ${dendro_recommender_interactions_table}\n"
elif [[ "${dr_stage2_active}" == "true" ]]
	then
		dendro_recommender_interactions_table="${interactions_table_stage2}"
		printf "${Cyan}[INFO]${Color_Off} Stage 2 of recommender is set as active. Interactions table will be ${dendro_recommender_interactions_table}\n"
else
	printf "${Red}[ERROR]${Color_Off} Either stage 1 or stage 2 of dendro recommender must be active..."
	exit
fi

#check out dendro code from svn repo
info "Installing Dendro to path : ${dendro_installation_path}\n"
sudo rm -rf $dendro_installation_path
cd $temp_downloads_folder
info "Exporting Dendro from GIT at : ${dendro_git_url} to $dendro_installation_path. PLEASE STAND BY!\n"
#sudo svn -q --no-auth-cache export $dendro_svn_url $dendro_installation_path --username $svn_user --password $svn_user_password --force
sudo git clone $dendro_git_url $dendro_installation_path || die "Unable to fetch Dendro source code"

if [[ ! -z "$dendro_branch" ]]
then
  info "Checking out Dendro branch $dendro_branch..."
	cd $dendro_installation_path
  	sudo git checkout "$dendro_branch"
	cd -
fi

#give "dendro" user ownership of the installation
sudo chown -R $dendro_user_name:$dendro_user_group $installation_path
sudo chmod -R 0755 $installation_path

#install dependencies
cd $dendro_installation_path || die "Unable to go back to dendro installation path at $dendro_installation_path"
sudo su - "$dendro_user_name" -c "source ~/.bashrc; cd $dendro_installation_path && npm install && grunt" || die "Unable to install npm dependencies at $dendro_installation_path as $dendro_user_name"
cd - || die "Unable to go back to previous installation dir"

#set active deployment configuration
echo "{\"key\" : \"${active_deployment_setting}\"}" | sudo tee $dendro_installation_path/conf/active_deployment_config.json

#give "dendro" user ownership of the installation
sudo chown -R $dendro_user_name:$dendro_user_group $installation_path

success "Installed Dendro into ${dendro_installation_path}"

#go back to initial dir
cd $setup_dir
