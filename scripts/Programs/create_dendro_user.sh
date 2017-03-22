#!/usr/bin/env bash

if [ -z ${DIR+x} ]; then
	#running by itself
	source ../constants.sh
else
	#running from dendro_full_setup_ubuntu_server_ubuntu_16.sh
	source ./constants.sh
fi

#save current dir
setup_dir=$(pwd) &&

#user exists?
id -u $dendro_user_name > /dev/null 2>&-

if [[ "$?" -eq "1" ]]; then
	info "Creating user $dendro_user_name"
	sudo useradd $dendro_user_name &&
	success "Created user $dendro_user_name" || die "Failed to create user ${dendro_user_name}."
else
	info "User ${dendro_user_name} already exists, no need to create it again."
fi

if [[ ! -d $dendro_user_home_folder ]]
then
	sudo mkdir -p $dendro_user_home_folder
	sudo chown -R $dendro_user_name $dendro_user_home_folder
fi

#group exists?
if [ "$(getent group ${dendro_user_group})" ]; then
  info "Group ${dendro_user_group} exists. It is not necessary to create it again."
else
  info "Group $dendro_user_group does not exist. Creating..."
	sudo addgroup $dendro_user_group || die "Failed to create group ${dendro_user_group}."
fi

#add user to group
sudo usermod -a -G $dendro_user_group $dendro_user_name &&
echo "${dendro_user_name}:${dendro_user_password}" | sudo chpasswd ||
die "Failed to create ${dendro_user_name} user."

#go back to initial dir
cd $setup_dir
