#!/usr/bin/env bash

if [ -z ${DIR+x} ]; then 
	#running by itself
	source ../constants.sh
else 
	#running from dendro_full_setup_ubuntu_server_ubuntu_16.sh
	source ./constants.sh
fi

function check_status
{
#	echo $1 $2
	result=$(sudo systemctl is-active $1)
#	echo $result
	if [ $result == 'inactive' ] 
	then
		sudo systemctl status $1
		journalctl -alb -u $1
	else
		printf "$2 status: $result"
	fi
	
	printf "\n"
}

printf "###################	Services STATUS	###################"
printf "\n"
check_status elasticsearch ElasticSearch
check_status mongodb MongoDB
check_status virtuoso Virtuoso
check_status $dendro_service_name "Dendro Instance $dendro_service_name"
check_status $dendro_recommender_service_name "Dendro Recommender Instance \"$dendro_recommender_service_name\""
