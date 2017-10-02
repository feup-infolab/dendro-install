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

info "Generating Configuration Files..."

if [[ "${dr_stage1_active}" == "true" ]]
then
	dendro_recommender_interactions_table="${interactions_table_stage1}"
	printf "${Cyan}[INFO]${Color_Off} Stage 1 of recommender is set as active. Interactions table will be ${dendro_recommender_interactions_table}\n"
elif [[ "${dr_stage2_active}" == "true" ]]
	then
		dendro_recommender_interactions_table="${interactions_table_stage2}"
		printf "${Cyan}[INFO]${Color_Off} Stage 2 of recommender is set as active. Interactions table will be ${dendro_recommender_interactions_table}\n"
else
	printf "${Red}[ERROR]${Color_Off} Either stage 1 or stage 2 of dendro recommender must be active..."
	exit
fi

nodejs $running_folder/build_configuration_files.js \
	--dr_config_output_folder_location "${running_folder}/generated_configurations" \
	--dendro_config_output_folder_location "${running_folder}/generated_configurations" \
	--dr_config_template_abs_path "${running_folder}/DendroRecommender/application.conf.template" \
	--config_identifier $active_deployment_setting \
	--port $dendro_port \
	--host $dendro_host  \
	--secret $secret \
	--base_uri $dendro_base_uri \
	--eudat_base_url $eudat_base_url \
	--eudat_token $eudat_token \
	--eudat_community_id $eudat_community_id \
	--elasticsearch_port $elasticsearch_port \
	--elasticsearch_host $elasticsearch_host \
	--cache_active $cache_active \
	--cache_type $cache_type \
	--redis_cache_active $redis_cache_active \
	--redis_cache_host $redis_cache_host \
	--redis_default_port $redis_default_port \
	--redis_social_port $redis_social_port \
	--redis_notification_port $redis_notification_port \
	--mongodb_cache_active $mongodb_cache_active \
	--mongodb_cache_host $mongodb_cache_host \
	--mongodb_cache_port $mongodb_cache_port \
	--mongodb_cache_database $mongodb_cache_database \
	--last_modified_caching $last_modified_caching \
	--cache_period_in_seconds $cache_period_in_seconds \
	--virtuoso_host $virtuoso_host \
	--virtuoso_port $virtuoso_port \
	--virtuoso_isql_port $virtuoso_isql_port \
	--virtuoso_dba_user $virtuoso_dba_user \
	--virtuoso_dba_password $virtuoso_dba_password \
	--virtuoso_sql_loglevel $virtuoso_sql_loglevel \
	--mongodb_host $mongodb_host \
	--mongodb_port $mongodb_port \
	--mongodb_dba_user $mongodb_dba_user \
	--mongodb_dba_password $mongodb_dba_password \
	--mongodb_files_collection_name $mongodb_files_collection_name \
	--mongodb_sessions_store_collection_name $mongodb_sessions_store_collection_name \
	--mysql_host $mysql_host \
	--mysql_port $mysql_port \
	--mysql_dba_user $mysql_username \
	--mysql_password $mysql_root_password \
	--mysql_db_name $mysql_database_to_create \
	--max_upload_size $max_upload_size \
	--max_project_size $max_project_size \
	--temp_files_directory $temp_files_directory \
	--temp_uploads_files_directory $temp_uploads_files_directory \
	--demo_mode_active $demo_mode_active \
	--dendro_theme $dendro_theme \
	--load_databases_on_startup $load_databases_on_startup \
	--reload_administrators_on_startup $reload_administrators_on_startup \
	--reload_demo_users_on_startup $reload_demo_users_on_startup \
	--reload_ontologies_on_startup $reload_ontologies_on_startup \
	--reload_descriptors_on_startup $reload_descriptors_on_startup \
	--clear_session_store_on_startup $clear_session_store_on_startup \
	--pipe_console_to_logfile $pipe_console_to_logfile \
	--log_request_times $logging_log_request_times \
	--custom_exception_logging $logging_custom_exception_logging \
	--config_human_readable_name $config_human_readable_name \
	--dendro_recommender_active $dendro_recommender_active \
	--dendro_recommender_host $dendro_recommender_host \
	--dendro_recommender_port $dendro_recommender_port \
	--dr_all_ontologies_uri $dendro_recommender_all_ontologies_url \
	--interactions_table_stage1 $interactions_table_stage1 \
	--interactions_table_stage2 $interactions_table_stage2 \
	--dr_stage1_active $dr_stage1_active \
	--dr_stage2_active $dr_stage2_active \
	--project_descriptors_recommender_active $project_descriptors_recommender_active \
	--emailing_account_gmail_reply_to_address $emailing_account_gmail_reply_to_address \
	--emailing_account_gmail_user $emailing_account_gmail_user \
	--emailing_account_gmail_password $emailing_account_gmail_password \
	--dr_all_ontologies_uri $dendro_recommender_all_ontologies_url \
	--dr_interactions_table $dendro_recommender_interactions_table \
	--gmaps_api_key $gmaps_api_key \
	--gmaps_map_height $gmaps_map_height \
	--google_analytics_tracking_code $google_analytics_tracking_code \
	--public_ontologies $public_ontologies \
	--default_authentication_enabled $default_authentication_enabled \
	--orcid_authentication_enabled $orcid_authentication_enabled \
	--orcid_client_id $orcid_client_id \
	--orcid_client_secret $orcid_client_secret \
	--orcid_auth_callback_url $orcid_auth_callback_url \
	--saml_authentication_enabled $saml_authentication_enabled \
	--saml_authentication_callback_path $saml_authentication_callback_path \
	--saml_authentication_entry_point $saml_authentication_entry_point \
	--saml_authentication_issuer $saml_authentication_issuer \
	--saml_authentication_button_text $saml_authentication_button_text \
	|| die "Failure generating configuration files."


success "Generated configuration files."
