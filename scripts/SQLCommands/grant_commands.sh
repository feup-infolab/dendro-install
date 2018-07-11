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

function wait_for_virtuoso_to_boot()
{
	echo "Waiting for virtuoso to boot up..."
	wait_for_server_to_boot_on_port "127.0.0.1" "8890"
	wait_for_server_to_boot_on_port "127.0.0.1" "1111"
}

wait_for_virtuoso_to_boot

# change the default password if it is set as default and the password is different
if [[ "${virtuoso_dba_password}" != "dba" ]]
then
	echo "set password dba ${virtuoso_dba_password};" | /usr/local/virtuoso-opensource/bin/isql 127.0.0.1 "dba" "dba"
fi

/usr/local/virtuoso-opensource/bin/isql 1111 "$virtuoso_dba_user" "$virtuoso_dba_password" < $running_folder/interactive_sql_commands.sql || die "Unable to load ontologies into Virtuoso."
/usr/local/virtuoso-opensource/bin/isql 1111 "$virtuoso_dba_user" "$virtuoso_dba_password" < $running_folder/declare_namespaces.sql || die "Unable to setup namespaces"

success "Installed base ontologies in virtuoso."

#go back to initial dir
cd $setup_dir
