#!/usr/bin/env bash

if [ -z ${DIR+x} ]; then
	#running by itself
	source ../constants.sh
else
	#running from dendro_full_setup_ubuntu_server_ubuntu_16.sh
	source ./constants.sh
fi

function wait_for_mongodb_to_boot()
{
    echo "Waiting for mongodb to boot up..."
    attempts=0
    max_attempts=30
    while ( nc 127.0.0.1 27017 < /dev/null )  && [[ $attempts < $max_attempts ]] ; do
        attempts=$((attempts+1))
        sleep 1;
        echo "waiting... (${attempts}/${max_attempts})"
    done
}


info "Installing latest MongoDB......"

#save current dir
setup_dir=$(pwd)

sudo rm -rf /etc/systemd/system/mongodb.service &&
sudo touch /etc/systemd/system/mongodb.service &&

#create pids folder...
sudo mkdir -p $dendro_installation_path/service_pids &&

printf "[Unit]
Description=High-performance, schema-free document-oriented database
\n
[Service]
Type=simple
Restart=on-failure
RestartSec=5s
RuntimeMaxSec=infinity
TimeoutStartSec=infinity
Environment=HOME=/root
User=mongodb
Group=mongodb
ExecStart=/usr/bin/mongod --quiet
PIDFile=$installation_path/service_pids/mongodb.pid
\n
[Install]
WantedBy=multi-user.target\n" | sudo tee /etc/systemd/system/mongodb.service &&


sudo mkdir -p /data/db
sudo chown mongodb /data/db/mongod.lock
sudo chown -R mongodb /data/db

#set elasticsearch startup service
sudo chmod 0744 /etc/systemd/system/mongodb.service &&
sudo systemctl daemon-reload &&
sudo systemctl enable mongodb &&
sudo systemctl unmask mongodb || die "Unable to create MongoDB service"
sudo systemctl start mongodb || die "Unable to start MongoDB service"

# enable authentication
IFS='%'
read -r -d '' old_conf_file_port_section << BUFFERDELIMITER
  authorization: disabled
BUFFERDELIMITER
unset IFS

IFS='%'
read -r -d '' new_conf_file_port_section << BUFFERDELIMITER
  authorization: enabled
BUFFERDELIMITER
unset IFS

#change default password of mongodb database if it is open	
if echo "exit" > mongo admin
then
	sudo systemctl stop mongodb || die "Unable to stop MongoDB service"
	patch_file $mongodb_conf_file "$old_conf_file_port_section" "$new_conf_file_port_section" \ 
		"mongodb_enable_authentication_patch" \
		&& success "Authentication enabled in MongoDB." || die "Unable to patch MongoDB configuration file: $mongodb_conf_file."
		
	sudo systemctl start mongodb || die "Unable to start MongoDB service after enabling authentication"
		
	wait_for_mongodb_to_boot
		
	echo "db.createUser( \
	{ \
	    user: \"$mongodb_dba_user\", \
	    pwd: \"$mongodb_dba_password\", \
	    roles: [ \"root\" ] \
	}); \
	quit(); " > mongo admin
	
	sudo systemctl restart mongodb || die "Unable to restart MongoDB service after creating \"$mongodb_dba_user\" user with the password set in secrets.sh and root role!"

	wait_for_mongodb_to_boot
		
	if echo "exit" > mongo admin -u "$mongodb_dba_user" -p "$mongo_dba_user" --authenticationDatabase admin
	then
		
	fi
fi



#go back to initial dir
cd $setup_dir

success "Finished setting up MongoDB service."
