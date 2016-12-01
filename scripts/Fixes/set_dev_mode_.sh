#!/usr/bin/env bash

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

#MongoDB
info "Opening MongoDB to ANY remote connection."
patch_file $mongodb_conf_file "bind_ip: 127.0.0.1" "#bind_ip: 127.0.0.1"
sudo service mongodb restart | die "Unable to patch mongodb configuration file."
success "Opened MongoDB."

##ElasticSearch
info "Opening ElasticSearch to ANY remote connection..."
patch_file $elasticsearch_conf_file "network.host: 127.0.0.1" "network.host: 0.0.0.0"
sudo service elasticsearch restart | die "Unable to patch ElasticSearch configuration file."
success "Opened ElasticSearch."

##Redis
info "Opening Redis to ANY remote connection..."
patch_file $redis_conf_file "bind 127.0.0.1" "bind 0.0.0.0"
sudo service redis restart | die "Unable to patch Redis configuration file."
success "Opened Redis."

#MySQL
info "Opening MySQL to ANY remote connection."
patch_file $mysql_conf_file "bind-address            = 127.0.0.1" "#bind-address            = 127.0.0.1" | die "Unable to patch MySQL configuration file."

mysql 	--user="$user" \
		--password="$password" \
		--database="$database" \
		--execute="GRANT ALL PRIVILEGES ON *.* TO '$mysql_username'@'%' IDENTIFIED BY '$mysql_root_password' WITH GRANT OPTION;
 FLUSH PRIVILEGES;"

sudo service mysql restart | die "Unable to enable MySQL remote access."
success "Opened MySQL."


#go back to initial dir
cd $setup_dir

#all ok.
success "This Dendro instance is in dev mode."
warning "DO NOT USE THIS IN PRODUCTION ENVIRONMENT. IT IS EXTREMELY INSECURE."
