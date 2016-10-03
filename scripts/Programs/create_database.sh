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

#create database to hold interaction logs
info "Creating MySQL database ${mysql_database_to_create} using user ${mysql_username}"
echo "create database ${mysql_database_to_create};" | mysql -u $mysql_username -p$mysql_root_password
success "MySQL database ${mysql_database_to_create} successfully created."

#go back to initial dir
cd $setup_dir
