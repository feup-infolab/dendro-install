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
    info "Waiting for mongodb to boot up..."
    wait_for_server_to_boot_on_port "127.0.0.1" "27017"
}

info "Installing MongoDB Community Edition......"

#save current dir
setup_dir=$(pwd) &&

#install Java 8
sudo apt-get install -y python-software-properties debconf-utils
sudo add-apt-repository -y ppa:webupd8team/java
sudo apt-get update
echo "oracle-java8-installer shared/accepted-oracle-license-v1-1 select true" | sudo debconf-set-selections
sudo apt-get install -y oracle-java8-installer

#install mongodb 10g
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 0C49F3730359A14518585931BC711F9BA15703C6 && 
echo "deb [ arch=amd64,arm64 ] http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.4 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.4.list &&
sudo apt-get -qq update &&
sudo apt-get -y install -f mongodb-org &&
sudo systemctl enable mongod.service && 
sudo systemctl daemon-reload &&
sudo service mongod start &&
sudo service mongod restart || die "Unable to start mongodb service!"

sudo mkdir -p /data/db &&
sudo chown -R mongodb /data/db &&
sudo service mongod restart || die "Unable to create /data/db directory for mongodb!"

# enable mongodb authentication
IFS='%'
read -r -d '' old_conf_file_port_section << BUFFERDELIMITER
#security:
BUFFERDELIMITER
unset IFS

IFS='%'
read -r -d '' new_conf_file_port_section << BUFFERDELIMITER
security:
  authorization: enabled
BUFFERDELIMITER
unset IFS

IFS='%'
read -r -d '' create_user_query << BUFFERDELIMITER
db.createUser(
	{
		user: "$mongodb_dba_user", 
		pwd: "$mongodb_dba_password", 
		roles: [ { role: "userAdminAnyDatabase", db: "admin" } ]
	}
);
BUFFERDELIMITER
unset IFS

IFS='%'
read -r -d '' authenticate_and_get_users_query << BUFFERDELIMITER
db.auth("$mongodb_dba_user", "$mongodb_dba_password" );
db.getUsers();
BUFFERDELIMITER
unset IFS

file_is_patched_for_line file_is_patched "$mongodb_conf_file" "$old_conf_file_port_section" "$new_conf_file_port_section" "mongodb_enable_authentication_patch"

if [ ! "$file_is_patched" ]
then
	info "File $mongodb_conf_file is not patched. Patching now..."
	sudo service mongod stop || die "Unable to stop MongoDB service"
	patch_file "$mongodb_conf_file" "$old_conf_file_port_section" "$new_conf_file_port_section" "mongodb_enable_authentication_patch" || die "Unable to patch MongoDB configuration file: $mongodb_conf_file."	
	sudo service mongod start || die "Unable to start MongoDB service after enabling authentication"
fi 

wait_for_mongodb_to_boot

#change default password of mongodb database if it is open	
if ! mongo -u "$mongodb_dba_user" -p "$mongodb_dba_password" --authenticationDatabase "admin"
then		
	info "Creating $mongodb_dba_user user with password..."

	echo "$create_user_query"
	mongo admin --eval "$create_user_query"

	info "Restarting mongodb..."
	sudo service mongod restart || die "Unable to restart MongoDB service after creating \"$mongodb_dba_user\" user with the password set in secrets.sh and root role!"

	wait_for_mongodb_to_boot	
	info "Trying to reconnect to mongodb as user $mongodb_dba_user..."
	echo "$authenticate_and_get_users_query"
	mongo admin --eval "$authenticate_and_get_users_query" || die "Unable to login as $mongodb_dba_user after setting authentication password." 

	# info "Logging in again..."
	# mongo admin -u "$mongodb_dba_user" \ 
	# 			-p "$mongodb_dba_user" \ 
	# 			--authenticationDatabase "admin" \ 
	# 			--eval "db.getUsers();"
fi

#go back to initial dir
cd "$setup_dir" || die "Unable to cd to $setup_dir"
success "Installed latest MongoDB Community Edition."

#SCRAP

#Apply locales fix...
# line="LC_ALL=\"en_GB.utf8\""
#
# if [ -f /etc/environment.bak_before_dendro_setup ]
# then
# 	echo "[INFO] Locales fix already applied. Continuing..."
# else
# 	echo "[INFO] Adding locales fix..."
# 	sudo cp /etc/environment /etc/environment.bak_before_dendro_setup
# 	echo $line | sudo tee -a /etc/environment
# fi

# command="cat /etc/environment | grep '${line}'"
# echo $command
# result=$(command)
# echo "Result = ${result}"

# sudo rm -rf /etc/environment.bak_before_dendro_setup

# #install MongoDB (because the official guide does not work...)
# #https://stackoverflow.com/questions/28945921/e-unable-to-locate-package-mongodb-org
#
# #Step 1:  Import the MongoDB public key
# sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 58712A2291FA4AD5
#
# #Step 2: Generate a file with the MongoDB repository url
# echo "deb http://repo.mongodb.org/apt/ubuntu "$(lsb_release -sc)"/mongodb-org/3.5 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.5.list
#
# #Step 3: Refresh the local database with the packages
# sudo apt-get update
#
# #Step 4: Install the last stable MongoDB version and all the necessary packages on our system
# sudo apt-get install mongodb
#
# #Because sometimes this folder is not created properly... go figure.
# sudo mkdir -p /data/db
# sudo chown -R mongodb /data/db



