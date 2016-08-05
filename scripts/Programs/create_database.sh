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
printf "${Cyan}[INFO]${Color_Off} Creating MySQL database ${mysql_database_to_create} using user ${mysql_username}\n"
echo "create database ${mysql_database_to_create};" | mysql -u $mysql_username -p$mysql_root_password
printf "${Green}[OK]${Color_Off} MySQL database ${mysql_database_to_create} successfully created.\n"

#go back to initial dir
cd $setup_dir

