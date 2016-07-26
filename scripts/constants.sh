#!/usr/bin/env bash

#global
active_deployment_setting='dendro_vagrant_demo'
#will be used to generate URLs relative to a base address, so set it wisely
	host="192.168.56.200" 
installation_path='/dendro'
recommender_installation_path='/dendro_recommender'

	#dependencies
		#mysql
		mysql_host='127.0.0.1'
		mysql_port='3306'
		mysql_database_to_create=$active_deployment_setting
		mysql_username='root'
		mysql_root_password='r00t_p4ssw0rd'

#svn users and passwords
svn_user="FIXME_____user_for_dendro_svn_repo"
svn_user_password="FIXME_____password_for_dendro_svn_repo"

#user who will own the installation folders and the dendro processes
dendro_user_name='dendro'
dendro_user_group='dendro'
dendro_user_password='dendr0'

#dendro
	#startup services
	dendro_service_name=$active_deployment_setting
	dendro_startup_item_file=/etc/systemd/system/$dendro_service_name.service
	
	#installation
	dendro_installation_path=$installation_path/$active_deployment_setting
	temp_downloads_folder='/tmp/dendro_setup'
	dendro_svn_url='http://dendro-dev.fe.up.pt/svn/dendro/'
	
	#deployment settings
	dendro_log_file=/var/log/$active_deployment_setting.log
	dendro_host=$host:3001
	dendro_port=3001
	dendro_base_uri="http://$dendro_host"
	temp_files_directory="/tmp/dendro/${active_deployment_setting}"
	demo_mode_active="true"
	dendro_theme="lumen"
	reload_administrators_on_startup="true"
	reload_demo_users_on_startup="true"
	config_human_readable_name='DendroVagrant'
	
	#eudat
	eudat_base_url="https://trng-b2share.eudat.eu"
	eudat_token="FIXME_____veryLongAndComplicatedString"

	#email account for messages and password recovery messaging
	emailing_account_gmail_user="FIXME_____gmail_user_to_send_emails"
	emailing_account_gmail_password="FIXME_____password_for_gmail_user_to_send_emails"

	#dependencies
		#elasticsearch
		elasticsearch_port=9200
		elasticsearch_host="127.0.0.1"
		
		#virtuoso
		virtuoso_host="127.0.0.1"
		virtuoso_port=8890
		virtuoso_dba_user="dba"
		virtuoso_dba_password="dba"
		virtuoso_startup_item_file='/etc/systemd/system/virtuoso.service'
		
			#virtuoso user (owner of the virtuoso installation and process)
			virtuoso_user='virtuoso'
			virtuoso_group='virtuoso'
			virtuoso_user_password='virtu0s0'
	
		#mongodb
		mongodb_host="127.0.0.1"
		mongodb_port=27017
		mongodb_dba_user="root"
		mongodb_dba_password="r00t"

#dendro recommender
	dendro_recommender_service_name=$active_deployment_setting-recommender
	dendro_recommender_startup_item_file=/etc/systemd/system/$dendro_recommender_service_name.service
	dendro_recommender_install_path=$recommender_installation_path/$active_deployment_setting
	dendro_recommender_active="true"
	dendro_recommender_svn_url='http://dendro-dev.fe.up.pt/svn/dendro_recommender/NewDendroRecommender/'
	dendro_recommender_host=$host
	dendro_recommender_port=9337
	dendro_recommender_log_file=/var/log/$active_deployment_setting-recommender.log
	
	dendro_recommender_all_ontologies_url="${dendro_base_uri}/ontologies/all"
	dendro_recommender_interactions_table="interactions_${active_deployment_setting}"
	
	#dependencies
		#play framework
		play_framework_install_path='/tmp/play'
		
		
#running variables help

get_script_dir () {
	SOURCE="${BASH_SOURCE[0]}"
	# While $SOURCE is a symlink, resolve it
	while [ -h "$SOURCE" ]; do
		DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
		SOURCE="$( readlink "$SOURCE" )"
		# If $SOURCE was a relative symlink (so no "/" as prefix, need to resolve it relative to the symlink base directory
		[[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE"
	done
	DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
	echo $DIR
}

cd_to_current_dir() {
	DIR="$(get_script_dir)"
	echo "[INFO] CD'ing to ${DIR}"
	cd "${DIR}"	
}

