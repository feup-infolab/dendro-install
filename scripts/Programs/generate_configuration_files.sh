#!/usr/bin/env bash

if [ -z ${DIR+x} ]; then 
	#running by itself
	source ../constants.sh
	script_dir=$(get_script_dir)
	running_folder='.'
else 
	#running from dendro_full_setup_ubuntu_server_ubuntu_16.sh
	source ./constants.sh
	script_dir=$(get_script_dir)
	running_folder=$script_dir/Programs
fi

printf "${Cyan}[INFO]${Color_Off} Generating Configuration Files...\n"

node $running_folder/build_configuration_files.js \
	--dr_config_output_folder_location "${running_folder}/generated_configurations" \
	--dendro_config_output_folder_location "${running_folder}/generated_configurations" \
	--dr_config_template_abs_path "${running_folder}/DendroRecommender/application.conf.template" \
	--config_identifier $active_deployment_setting \
	--port $dendro_port \
	--host $dendro_host  \
	--base_uri $dendro_base_uri \
	--eudat_base_url $eudat_base_url \
	--eudat_token $eudat_token \
	--elasticsearch_port $elasticsearch_port \
	--elasticsearch_host $elasticsearch_host \
	--virtuoso_host $virtuoso_host \
	--virtuoso_port $virtuoso_port \
	--virtuoso_dba_user $virtuoso_dba_user \
	--virtuoso_dba_password $virtuoso_dba_password \
	--mongodb_host $mongodb_host \
	--mongodb_port $mongodb_port \
	--mongodb_dba_user $mongodb_dba_user \
	--mongodb_dba_password $mongodb_dba_password \
	--redis_host $redis_host \
	--redis_port $redis_port \
	--redis_database $redis_database \
	--mysql_host $mysql_host \
	--mysql_port $mysql_port \
	--mysql_dba_user $mysql_username \
	--mysql_password $mysql_root_password \
	--mysql_db_name $mysql_database_to_create \
	--temp_files_directory $temp_files_directory \
	--demo_mode_active $demo_mode_active \
	--dendro_theme $dendro_theme \
	--reload_administrators_on_startup $reload_administrators_on_startup \
	--reload_demo_users_on_startup $reload_demo_users_on_startup \
	--config_human_readable_name $config_human_readable_name \
	--dendro_recommender_active $dendro_recommender_active \
	--dendro_recommender_host $dendro_recommender_host \
	--dendro_recommender_port $dendro_recommender_port \
	--interactions_table_stage1 $interactions_table_stage1 \
	--interactions_table_stage2 $interactions_table_stage2 \
	--emailing_account_gmail_user $emailing_account_gmail_user \
	--emailing_account_gmail_password $emailing_account_gmail_password \
	--cache_static_files $cache_static_files \
	--dr_all_ontologies_uri $dendro_recommender_all_ontologies_url \
	--dr_interactions_table $dendro_recommender_interactions_table \
	--dr_stage1_active $dr_stage1_active \
	--dr_stage2_active $dr_stage2_active 

printf "${Yellow}[INFO]${Color_Off} Generated Configuration Files. Check for errors.\n"