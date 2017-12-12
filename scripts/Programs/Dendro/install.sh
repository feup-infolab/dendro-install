#!/usr/bin/env bash

source ./constants.sh
source ./secrets.sh

#save current dir
setup_dir=$(pwd)
echo "$setup_dir"

info "Installing Dendro $dendro_service_name at $installation_path..."

#activate nvm
export NVM_DIR="$HOME/.nvm" &&
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

nvm > /dev/null

if [ "$?" == "1" ]
then
	echo "NVM is not installed for user $(whoami)!" &&
	exit 1
else
	cd $dendro_installation_path
    $dendro_installation_path/conf/scripts/install.sh
fi

#set active deployment configuration
echo "{\"key\" : \"${active_deployment_setting}\"}" | tee $dendro_installation_path/conf/active_deployment_config.json || die "Unable to set Active Configuration $active_deployment_setting in file $dendro_installation_path/conf/active_deployment_config.json"

#give "dendro" user ownership of the installation
chown -R $dendro_user_name:$dendro_user_group $installation_path && info "Successfully Installed Dendro at $dendro_installation_path" || die "Unable to set $dendro_user_name:$dendro_user_group as owner of $installation_path."
