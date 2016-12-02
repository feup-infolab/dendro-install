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

warning "[[[Setting up this Dendro instance for development.]]]"
file_exists_flag="true"

#MongoDB
info "Trying to open MongoDB to ANY remote connection."
file_exists file_exists_flag $mongodb_conf_file
if [[ "$file_exists_flag" == "true" ]]; then
	patch_file $mongodb_conf_file "^bind_ip: 127.0.0.1" "#bind_ip: 127.0.0.1" "mongodb_dendro_dev_patch" && success "Opened MongoDB." || die "Unable to patch mongodb configuration file."
	sudo service mongodb restart | die "Unable to restart mongodb service."
else
	die "File $mongodb_conf_file does not exist."
fi


##ElasticSearch
info "Trying to open ElasticSearch to ANY remote connection."
file_exists file_exists_flag $elasticsearch_conf_file
if [[ "$file_exists_flag" == "true" ]]; then
	info "Trying to open  ElasticSearch to ANY remote connection..."
	patch_file $elasticsearch_conf_file "^network.host: 127.0.0.1" "network.host: 0.0.0.0" "elasticsearch_dendro_dev_patch" && success "Opened ElasticSearch." || die "Unable to patch ElasticSearch configuration file."
	sudo service elasticsearch restart | die "Unable to restart ElasticSearch service."
else
	die "File $elasticsearch_conf_file does not exist."
fi

##Redis
info "Trying to open Redis to ANY remote connection."
file_exists file_exists_flag $redis_conf_file
if [[ "$file_exists_flag" == "true" ]]; then
	info "Trying to open  Redis to ANY remote connection..."
	patch_file $redis_conf_file "^bind 127.0.0.1" "bind 0.0.0.0" "redis_dendro_dev_patch"  && success "Opened Redis." || die "Unable to patch Redis configuration file."
	sudo service redis restart | die "Unable to restart Redis service."
else
	die "File $redis_conf_file does not exist."
fi


#MySQL
info "Trying to open MySQL to ANY remote connection."
file_exists file_exists_flag $mysql_conf_file
if [[ "$file_exists_flag" == "true" ]]; then	
	info "Trying to open  MySQL to ANY remote connection."
	patch_file $mysql_conf_file "^bind-address            = 127.0.0.1" "#bind-address            = 127.0.0.1" "mysql_dendro_dev_patch"  && success "Opened MySQL." || die "Unable to patch MySQL configuration file."

	mysql 	--user="$user" \
		--password="$password" \
		--database="$database" \
		--execute="GRANT ALL PRIVILEGES ON *.* TO '$mysql_username'@'%' IDENTIFIED BY '$mysql_root_password' WITH GRANT OPTION;
 FLUSH PRIVILEGES;"
 sudo service mysql restart | die "Unable to enable MySQL remote access."
else
	die "File $mongodb_conf_file does not exist."
fi



#go back to initial dir
cd $setup_dir

#all ok.
success "This Dendro instance is in dev mode."
warning "DO NOT USE THIS IN PRODUCTION ENVIRONMENT. IT IS EXTREMELY INSECURE."
