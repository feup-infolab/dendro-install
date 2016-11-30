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

##ElasticSearch
info "Opening ElasticSearch to ANY remote connection..."

success "Opened ElasticSearch."


##Redis
info "Opening Redis to ANY remote connection..."


success "Opened Redis."

#MySQL
info "Opening MySQL to ANY remote connection."

success "Opened MySQL."




#go back to initial dir
cd $setup_dir

#all ok.
success "This Dendro instance is in dev mode. DO NOT USE THIS IN PRODUCTION ENVIRONMENT, IT IS UNSAFE."
