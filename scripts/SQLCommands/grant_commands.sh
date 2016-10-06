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

timeout=30
info "Waiting for virtuoso service to start. Installing base ontologies in virtuoso in $timeout seconds..."
for (( i = 0; i < $timeout; i++ )); do
	echo -ne $[$timeout-i]...
	sleep 1s
done
echo

/usr/local/virtuoso-opensource/bin/isql < $running_folder/interactive_sql_commands.sql ||
die "Unable to load ontologies into Virtuoso."

success "Installed base ontologies in virtuoso."

#go back to initial dir
cd $setup_dir
