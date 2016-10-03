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
sudo systemctl stop $dendro_service_name

#check out dendro code from svn repo
info "Installing Dendro to path : ${dendro_installation_path}\n"
sudo rm -rf $dendro_installation_path
cd $temp_downloads_folder
info "Exporting Dendro from GIT at : ${dendro_git_url} to $dendro_installation_path. PLEASE STAND BY!\n"
#sudo svn -q --no-auth-cache export $dendro_svn_url $dendro_installation_path --username $svn_user --password $svn_user_password --force
sudo git clone $dendro_git_url $dendro_installation_path

#give "dendro" user ownership of the installation
sudo chown -R $dendro_user_name:$dendro_user_group $installation_path
sudo chmod -R 0755 $installation_path

#install npm dependencies
cd $dendro_installation_path
sudo npm update && sudo npm install
cd -

#install bower dependencies
cd $dendro_installation_path/public
bower install --allow-root
cd -

#set active deployment configuration
echo "{\"key\" : \"${active_deployment_setting}\"}" | sudo tee $dendro_installation_path/conf/active_deployment_config.json

success "Installed Dendro into ${dendro_installation_path}"

#go back to initial dir
cd $setup_dir
