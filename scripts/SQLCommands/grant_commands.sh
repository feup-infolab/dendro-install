#!/usr/bin/env bash

#save current dir
setup_dir=$(pwd)

if [ -z ${DIR+x} ]; then 
	#running by itself
	source ../constants.sh
	script_dir=$(get_script_dir)
	running_folder='.'
else 
	#running from dendro_full_setup_ubuntu_server_ubuntu_16.sh
	source ./constants.sh
	script_dir=$(get_script_dir)
	running_folder=$script_dir/SQLCommands
fi

printf "${Cyan}[INFO]${Color_Off} Installing base ontologies in virtuoso in 5 seconds...\n"
for (( i = 0; i < 10; i++ )); do
	echo $[10-i]...
	sleep 1s
done

/usr/local/virtuoso-opensource/bin/isql < $running_folder/interactive_sql_commands.sql
printf "${Green}[OK]${Color_Off} Installed base ontologies in virtuoso.\n"

#go back to initial dir
cd $setup_dir