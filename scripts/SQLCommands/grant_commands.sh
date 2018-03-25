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

function wait_for_server_to_boot_on_port()
{
    local port=$1
    local attempts=0
    local max_attempts=60

    echo "Waiting for server on port $port to boot up..."

    while (
						nc 127.0.0.1 "$port" < /dev/null ||
						telnet 127.0.0.1 $port
					) && [[ $attempts < $max_attempts ]] ; do
        attempts=$((attempts+1))
        if [[ "$attempts" == "$max_attempts" ]]
        then
            break;
        else
            sleep 1;
            echo "waiting... (${attempts}/${max_attempts})"
        fi
    done

		if [[ "$attempts" == "$max_attempts" ]]
    then
				echo "Server on port $port failed to start after $max_attempts"
		else
			echo "Server on port $port started successfully at attempt (${attempts}/${max_attempts})"
    fi
}

sudo service virtuoso start

# echo "sleeping for 30 seconds before attempting to load ontologies into virtuoso"
# sleep 30

wait_for_server_to_boot_on_port 8890
wait_for_server_to_boot_on_port 1111

echo "trying to run ontology loading commands in virtuoso"

/usr/local/virtuoso-opensource/bin/isql 1111 "$virtuoso_dba_user" "$virtuoso_dba_password" < $running_folder/interactive_sql_commands.sql

# change the default password if it is set as default and the password is different
if [[ "${virtuoso_dba_password}" != "dba" ]]
then
	echo "set password dba ${virtuoso_dba_password};" | /usr/local/virtuoso-opensource/bin/isql 127.0.0.1 "dba" "dba" || die "Unable to set the custom password for virtuoso user $virtuoso_dba_user"
fi

#go back to initial dir
cd $setup_dir
