#!/usr/bin/env bash

#global
active_deployment_setting='dendroVagrantDemo'
#will be used to generate URLs relative to a base address, so set it wisely
	host="192.168.56.249"
installation_path='/dendro'
recommender_installation_path='/dendro_recommender'

	#dependencies
		#mysql
		mysql_host='127.0.0.1'
		mysql_port='3306'
		mysql_database_to_create=$active_deployment_setting

#dendro
	#startup services
	dendro_service_name=$active_deployment_setting
	dendro_startup_item_file=/etc/systemd/system/$dendro_service_name.service

	#installation
	dendro_installation_path=$installation_path/$active_deployment_setting
	temp_downloads_folder='/tmp/dendro_setup'
	dendro_svn_url='http://dendro-dev.fe.up.pt/svn/dendro/'
	dendro_git_url='https://github.com/feup-infolab-rdm/dendro.git'

	#deployment settings
	dendro_log_file=/var/log/$active_deployment_setting.log
	dendro_port=3007
	dendro_host=$host:$dendro_port
	dendro_base_uri="http://$dendro_host"
	temp_files_directory="/tmp/dendro/${active_deployment_setting}"
	demo_mode_active="true"
	dendro_theme="lumen"
	reload_administrators_on_startup="true"
	reload_demo_users_on_startup="true"
	reload_ontologies_on_startup="true"
	config_human_readable_name='DendroVagrantDemo'

	#logging
 	logging_format="dev"
 	logging_app_logs_folder="logs/app"
 	logging_log_request_times="true"
 	logging_request_times_log_folder="logs/request_times"
 	logging_log_requests_in_apache_format="true"
 	logging_requests_in_apache_format_log_folder="logs/requests_apache_format"
 	#version
 	config_human_readable_name='Dendro RDM Demo @ UPorto'

	#descriptor recommendation
	interactions_table_stage1="interactions_${active_deployment_setting}_stage1"
	interactions_table_stage2="interactions_${active_deployment_setting}_stage2"

	dr_stage1_active="false"
	dr_stage2_active="true"

	#eudat
	eudat_base_url="https://trng-b2share.eudat.eu"

	#cache static files such as images or thumbnails
	last_modified_caching="true"
	cache_period_in_seconds=3600

	#gmaps API key

	gmaps_map_height=500

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

		#mongodb
		mongodb_host="127.0.0.1"
		mongodb_port=27017
		mongodb_collection_name="${active_deployment_setting}_data"

		#redis
		redis_port=6379
		redis_host="127.0.0.1"
		redis_database=1

#dendro recommender
	dendro_recommender_service_name=$active_deployment_setting-recommender
	dendro_recommender_startup_item_file=/etc/systemd/system/$dendro_recommender_service_name.service
	dendro_recommender_install_path=$recommender_installation_path/$active_deployment_setting
	dendro_recommender_active="true"

	dendro_recommender_svn_url='http://dendro-dev.fe.up.pt/svn/dendro_recommender/NewDendroRecommender/'
	dendro_recommender_git_url='https://github.com/feup-infolab-rdm/dendro-recommender.git'

	dendro_recommender_host=$host
	dendro_recommender_port=9007
	dendro_recommender_log_file=/var/log/$active_deployment_setting-recommender.log

	dendro_recommender_all_ontologies_url="${dendro_base_uri}/ontologies/all"

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

	#dependencies
		#play framework
		play_framework_install_path='/tmp/play'


#running variables help

get_script_dir  () {
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

cd_to_current_dir () {
	DIR="$(get_script_dir)"
	printf "${Cyan}[INFO]${Color_Off} CD'ing to ${DIR}\n"
	cd "${DIR}"
}

info () {
	printf "${Cyan}[INFO]${Color_Off} $1\n"
}

warning () {
	printf "${Yellow}[INFO]${Color_Off} $1\n"
}

success () {
	printf "${Green}[SUCCESS]${Color_Off} $1\n"
}

error () {
	printf "${Red}[ERROR]${Color_Off} $1\n"
}

die () {
	printf "${On_IRed}[FATAL ERROR]${Color_Off} $1\n${Red}Please check any prior error messages.${Color_Off}"
	exit 1
}

#console colors

# Reset
Color_Off='\033[0m'       # Text Reset

# Regular Colors
Black='\033[0;30m'        # Black
Red='\033[0;31m'          # Red
Green='\033[0;32m'        # Green
Yellow='\033[0;33m'       # Yellow
Blue='\033[0;34m'         # Blue
Purple='\033[0;35m'       # Purple
Cyan='\033[0;36m'         # Cyan
White='\033[0;37m'        # White

# Bold
BBlack='\033[1;30m'       # Black
BRed='\033[1;31m'         # Red
BGreen='\033[1;32m'       # Green
BYellow='\033[1;33m'      # Yellow
BBlue='\033[1;34m'        # Blue
BPurple='\033[1;35m'      # Purple
BCyan='\033[1;36m'        # Cyan
BWhite='\033[1;37m'       # White

# Underline
UBlack='\033[4;30m'       # Black
URed='\033[4;31m'         # Red
UGreen='\033[4;32m'       # Green
UYellow='\033[4;33m'      # Yellow
UBlue='\033[4;34m'        # Blue
UPurple='\033[4;35m'      # Purple
UCyan='\033[4;36m'        # Cyan
UWhite='\033[4;37m'       # White

# Background
On_Black='\033[40m'       # Black
On_Red='\033[41m'         # Red
On_Green='\033[42m'       # Green
On_Yellow='\033[43m'      # Yellow
On_Blue='\033[44m'        # Blue
On_Purple='\033[45m'      # Purple
On_Cyan='\033[46m'        # Cyan
On_White='\033[47m'       # White

# High Intensity
IBlack='\033[0;90m'       # Black
IRed='\033[0;91m'         # Red
IGreen='\033[0;92m'       # Green
IYellow='\033[0;93m'      # Yellow
IBlue='\033[0;94m'        # Blue
IPurple='\033[0;95m'      # Purple
ICyan='\033[0;96m'        # Cyan
IWhite='\033[0;97m'       # White

# Bold High Intensity
BIBlack='\033[1;90m'      # Black
BIRed='\033[1;91m'        # Red
BIGreen='\033[1;92m'      # Green
BIYellow='\033[1;93m'     # Yellow
BIBlue='\033[1;94m'       # Blue
BIPurple='\033[1;95m'     # Purple
BICyan='\033[1;96m'       # Cyan
BIWhite='\033[1;97m'      # White

# High Intensity backgrounds
On_IBlack='\033[0;100m'   # Black
On_IRed='\033[0;101m'     # Red
On_IGreen='\033[0;102m'   # Green
On_IYellow='\033[0;103m'  # Yellow
On_IBlue='\033[0;104m'    # Blue
On_IPurple='\033[0;105m'  # Purple
On_ICyan='\033[0;106m'    # Cyan
On_IWhite='\033[0;107m'   # White
