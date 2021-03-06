#!/usr/bin/env bash

dendro_config_output_folder_location="."

#tests branch
#if this variable is set
#AND the build is running in a jenkins server (env variable JENKINS_BUILD='1'),
#it will check out this dendro branch to inside the VM for testing
tests_branch="machine-plus-human-identifiers"

#global
active_deployment_setting='dendroVagrantDemo'
#will be used to generate URLs relative to a base address, so set it wisely
	host="192.168.56.249"
#node environment profile (test / production / development)
environment='development'
installation_path='/dendro'
recommender_installation_path='/dendro_recommender'

	#dependencies
		#mysql
		mysql_host='127.0.0.1'
		mysql_port='3306'
		mysql_database_to_create=$active_deployment_setting

	#uploads
		max_upload_size="2147483648"
		max_project_size="5368709120"

#dendro
	#startup services
	dendro_service_name=$active_deployment_setting
	dendro_startup_item_file=/etc/systemd/system/$dendro_service_name.service

	#installation
	dendro_installation_path="$installation_path/$active_deployment_setting"

	dendro_startup_scripts_path="$installation_path/startup_scripts"
	dendro_startup_script="$dendro_startup_scripts_path/$active_deployment_setting-start.sh"
	dendro_stop_script="$dendro_startup_scripts_path/$active_deployment_setting-stop.sh"
	dendro_reload_script="$dendro_startup_scripts_path/$active_deployment_setting-reload.sh"

	temp_downloads_folder='/tmp/dendro_setup'
	dendro_svn_url='http://dendro-dev.fe.up.pt/svn/dendro/'
	dendro_git_url='https://github.com/feup-infolab-rdm/dendro.git'

	#deployment settings
	dendro_log_file=/var/log/$active_deployment_setting.log
	dendro_port=3007
	dendro_host=$host:$dendro_port
	dendro_base_uri="http://$dendro_host"
	temp_files_directory="temp"
	temp_uploads_files_directory="temp_uploads"
	demo_mode_active="true"
	dendro_theme="lumen"
	config_human_readable_name='DendroVagrantDemo'

 	#version
 	config_human_readable_name='Dendro RDM Demo @ UPorto'

	#descriptor recommendation
	interactions_table_stage1="interactions_${active_deployment_setting}_stage1"
	interactions_table_stage2="interactions_${active_deployment_setting}_stage2"
	dr_interactions_table="interactions_${active_deployment_setting}_stage2"

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
		#nodejs version
		node_version="8.10.0"

		#elasticsearch
		elasticsearch_port=9200
		elasticsearch_host="127.0.0.1"

		#virtuoso
		virtuoso_host="127.0.0.1"
		virtuoso_port=8890
		virtuoso_isql_port=1111
		virtuoso_sql_loglevel=3
		virtuoso_startup_item_file='/etc/systemd/system/virtuoso.service'
		virtuoso_ini_path='/usr/local/virtuoso-opensource/var/lib/virtuoso/db/virtuoso.ini'

		#mongodb
		mongodb_host="127.0.0.1"
		mongodb_port=27017
		mongodb_files_collection_name="${active_deployment_setting}_data"
		mongodb_sessions_store_collection_name="${active_deployment_setting}_sessions"

		#jenkins
		jenkins_port=8080
		jenkins_config_file="/etc/default/jenkins"

	#cache
		cache_active="true"
		cache_type="mongodb"
			#redis
				redis_cache_active="true"
				redis_cache_host="127.0.0.1"
			#mongodb
				mongodb_cache_active="true"
				mongodb_cache_host="127.0.0.1"
				mongodb_cache_port="27017"
				mongodb_cache_database="192.168.56.249:3007"

#startup
	load_databases_on_startup="true"
	reload_administrators_on_startup="true"
	reload_demo_users_on_startup="true"
	reload_ontologies_on_startup="true"
	reload_descriptors_on_startup="true"
	clear_session_store_on_startup="false"

#logging
 	logging_level="debug"
 	logging_app_logs_folder="logs/app"
	logging_suppress_all_logs="false"
	logging_suppress_all_errors="false"
	#logging_log_all_requests="false"
	logging_log_emailing="false"

#dendro recommender
	dendro_recommender_service_name=$active_deployment_setting-recommender
	dendro_recommender_startup_item_file=/etc/systemd/system/$dendro_recommender_service_name.service
	dendro_recommender_install_path=$recommender_installation_path/$active_deployment_setting

	dendro_recommender_active="false"
	dendro_recommender_host=$host
	dendro_recommender_port=9007
	dendro_recommender_log_file=/var/log/$active_deployment_setting-recommender.log

	project_descriptors_recommender_active="true"

	dendro_recommender_svn_url='http://dendro-dev.fe.up.pt/svn/dendro_recommender/NewDendroRecommender/'
	dendro_recommender_git_url='https://github.com/feup-infolab-rdm/dendro-recommender.git'

	dendro_recommender_all_ontologies_url="${dendro_base_uri}/ontologies/all"

#public_ontologies
	public_ontologies="[\"foaf\",\"dcterms\",\"bdv\",\"research\",\"dcb\",\"tsim\",\"hdg\",\"ddiup\",\"disco\",\"biocn\",\"grav\",\"cep\",\"social\",\"tvu\",\"po\",\"m3lite\",\"ssn\"]"

#authentication
	#default
		default_authentication_enabled="true"
	#orcid
		orcid_authentication_enabled="true"
	#saml
		saml_authentication_enabled="false"
	#shibboleth
		shibboleth_authentication_enabled="false"

	#dependencies
		#play framework
		play_framework_install_path='/etc/play'
		play_framework_md5="cd59d02e49fce42bc87d230274c5701c"


#multi-core configuration
	num_cpus=1

#Vagrant-specific configuration

#VAGRANT_VM_SSH_USERNAME="vagrant"
#VAGRANT_VM_SSH_PASSWORD="vagrant"

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
	cd "${DIR}" || die "Unable to return to the current directory"
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
	printf "${On_IRed}[FATAL ERROR]${Color_Off} $1\n${Red}Please check any prior error messages.${Color_Off}\n"
	exit 1
}
file_is_patched_for_line()
{
	local file=$2
	local old_line=$3
	local new_line=$4
	local patch_tag=$5

	#printf "grep -q \"$patch_tag\" $file"
	local patched
	#info "GREP'ing for \"$patch_tag\"...:"
	grep "$patch_tag" $file > /dev/null
	patched="$?"

	if [ "$patched" == "0" ]
	then
			info "File $file has patch tag \"$patch_tag\"!"
    	eval "$1=\"true\""
	else
			info "File $file does not have patch tag \"$patch_tag\"!"
    	eval "$1=\"false\""
	fi
}

get_tmp_copy_of_file()
{
	local full_path=$2

	local filename=$(basename "$full_path")
	local extension="${filename##*.}"
	local name_only="${filename%.*}"

	local date="$(date +"%m_%d_%Y_%hh_%mm_%ss")"
	local tmp_folder_path="/tmp/dendro_file_patches/$date"
	local tmp_file_path="$tmp_folder_path/$filename"

	mkdir -p $tmp_folder_path

	touch "$tmp_file_path"

	eval "$1=\$tmp_file_path"
}

get_replacement_line()
{
	local old_line=$2
	local new_line=$3
	local patch_tag=$4
	local filename=$5
	local forced_extension=$6
	local extension=""

	if [[ "$forced_extension" == "" ]]
	then
		if [[ ! "$filename" == "" ]]
		then
			filename=$(basename "$filename")
			extension="${filename##*.}"
		else
			extension="sh"
		fi
	else
		extension="$forced_extension"
	fi

	#info "Getting replacement for extension $extension"

	case $extension in
		sh|properties|yaml|yml|conf|cnf)
			local replaced_line
			IFS='%'
			read -r -d '' replaced_line << BUFFERDELIMITER
#START_PATCH_TAG: $patch_tag
###START REPLACEMENT by Dendro install scripts
#OLD VALUE: $old_line
#NEW VALUE
$new_line
###END REPLACEMENT by Dendro install scripts
#END_PATCH_TAG: $patch_tag
BUFFERDELIMITER
			unset IFS
			;;
		xml)
			local replaced_line
			IFS='%'
			read -r -d '' replaced_line << BUFFERDELIMITER
<!-- START_PATCH_TAG: $patch_tag -->
<!-- START REPLACEMENT by Dendro install scripts -->
<!-- OLD VALUE: $old_line-->
<!-- NEW VALUE-->
$new_line
<!-- END REPLACEMENT by Dendro install scripts -->
<!-- END_PATCH_TAG: $patch_tag-->
BUFFERDELIMITER
			unset IFS
			;;
		ini)
			local replaced_line
			IFS='%'
			read -r -d '' replaced_line << BUFFERDELIMITER
;; START_PATCH_TAG: $patch_tag
;; START REPLACEMENT by Dendro install scripts
;; OLD VALUE: $old_line
;; NEW VALUE
$new_line
;; END REPLACEMENT by Dendro install scripts
;; END_PATCH_TAG: $patch_tag
BUFFERDELIMITER
			unset IFS
			;;
		*)
			die "Unknown file extension: $extension"
			;;
	esac

	eval "$1=\$replaced_line"
}

add_text_at_end_of_file()
{
	local file=$1
	local new_line=$2
	local tmp_copy=""

	#Create temporary file with new line in place
	get_tmp_copy_of_file tmp_copy $file

	cat file > $tmp_copy
	echo '\n' > $tmp_copy
	echo new_line > $tmp_copy

	#Copy the new file over the original file
	rm -rf $file
	cp $tmp_copy $file
}

add_line_at_end_of_file_if_tag_not_present()
{
	local file=$1
	local new_line=$2
	local tag=$3
	grep -q -F "####$tag" $file || echo "\'$new_line\'   ####$tag" >> $file
}

get_timestamp()
{
	eval "$1=\"$(date "+%Y_%m_%d-%H_%M_%S")\""
}

replace_text_in_file()
{
	local file=$1
	local old_line=$2
	local new_line=$3
	local tmp_copy=""

	#make file backup

	timestamp=""
	get_timestamp timestamp
	sudo cp $file $file'_'$timestamp.bak

	#replace multi-line string in file
	#from http://ask.xmodulo.com/search-and-replace-multi-line-string.html

	local node_exists=""
	node_exists=$(which nodejs)

	if [ "$?" == "1" ] || [ "$node_exists" == "" ]
	then
		info "NodeJS is not installed! Installing..."
		sudo apt-get install -y build-essential &&
		curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
		sudo apt-get install -y nodejs || die "Unable to install NodeJS"
	fi

	installation_scripts_dir="$(get_script_dir)"
	replacement_text=$(nodejs $installation_scripts_dir/Utils/replace.js "$old_line" "$new_line" "$file")
	sudo rm -rf $file
	echo "$replacement_text" | sudo tee $file >> /dev/null
}

file_exists()
{
	file=$2
	if [ ! -f $file ]; then
		eval "$1=\"false\""
	else
		eval "$1=\"true\""
	fi
}

patch_file()
{
	local file=$1
	local old_line=$2
	local new_line=$3
	local patch_tag=$4
	local forced_extension=$5

	#info "Forcing patch of $file with extension $forced_extension"
	local replacement_line
	local file_is_patched=""
	local file_exists_flag

	file_exists file_exists_flag $file

	if [ "$file_exists_flag" == "false" ]
	then
	    error "File $file not found!"
		return 1
	else
		file_is_patched_for_line file_is_patched "$file" "$old_line" "$new_line" "$patch_tag"

		if [ "$file_is_patched" == "true" ]
		then
			warning "File $file is already patched for patch $patch_tag."
		else
			get_replacement_line replacement_line "$old_line" "$new_line" "$patch_tag" "$file" "$forced_extension"
			if [ "$old_line" ==  "" ]
			then
				add_text_at_end_of_file "$file" "$replacement_line" "$patch_tag"
			else
				replace_text_in_file "$file" "$old_line" "$replacement_line" "$patch_tag"
				#info "Visual check if patch was applied:"
				file_is_patched_for_line file_is_patched "$file" "$old_line" "$new_line" "$patch_tag"
			fi
		fi
	fi
}

unpatch_file()
{
	echo 1
}

#take snapshot of VM
take_vm_snapshot()
{
	local vm_name=$1
	local operations=$2

	timestamp=""
	get_timestamp timestamp
	local snapshot_name=$vm_name'_'$timestamp'_'$operations

	info "Taking a snapshot of VM $vm_name with name $snapshot_name"
  VBoxManage snapshot $vm_name take $snapshot_name
}

# starts containers with the volumes mounted
function wait_for_server_to_boot_on_port()
{
    local ip=$1
    local sentenceToFindInResponse=$2

    if [[ $ip == "" ]]; then
      ip="127.0.0.1"
    fi
    local port=$2
    local attempts=0
    local max_attempts=60

    info "Waiting for server on $ip:$port to boot up..."

    response=$(curl -s $ip:$port)
    echo "$response"

	until $(curl --output /dev/null --silent --head --fail http://$ip:$port) || [[ $attempts > $max_attempts ]]; do
        attempts=$((attempts+1))
        info "waiting... (${attempts}/${max_attempts})"
        sleep 1;
	done

    if (( $attempts == $max_attempts ));
    then
        die "Server on $ip:$port failed to start after $max_attempts"
    elif (( $attempts < $max_attempts ));
    then
        success "Server on $ip:$port started successfully at attempt (${attempts}/${max_attempts})"
    fi
}

#configuration files for servers
# redis_conf_file=/Users/joaorocha/Desktop/confs/redis.conf
# elasticsearch_conf_file=/Users/joaorocha/Desktop/confs/elasticsearch.yml
# mongodb_conf_file=/Users/joaorocha/Desktop/confs/mongodb.conf
# mysql_conf_file=/Users/joaorocha/Desktop/confs/mysqld.cnf

redis_conf_folder="/etc/redis"
redis_conf_file="$redis_conf_folder/redis.conf"
redis_init_script_file="/etc/init.d/redis-server"

elasticsearch_conf_file=/etc/elasticsearch/elasticsearch.yml
mongodb_conf_file=/etc/mongod.conf
mysql_conf_file=/etc/mysql/mysql.conf.d/mysqld.cnf

#redis instances (one per dendro graph to separate cached resources)

redis_cache_host="127.0.0.1"

redis_default_port="6780"
redis_social_port="6781"
redis_notification_port="6782"

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

#teamcity (General)
	teamcity_installation_path='/TeamCity'
	teamcity_control_scripts_path="$teamcity_installation_path/control_scripts"
	teamcity_agent_installation_path="$teamcity_installation_path/buildAgent"
	teamcity_pids_folder="$teamcity_installation_path/logs"
	teamcity_cookies_file="/tmp/teamcity_setup/teamcity_cookies.txt"

	teamcity_url="https://download.jetbrains.com/teamcity/TeamCity-10.0.4.tar.gz"
	#teamcity_url="http://10.0.2.3/TeamCity-10.0.4.tar.gz" #macbook pro
	teamcity_md5="30aa7af265e8e68d12002308d80f62ef"

#Teamcity Server
	teamcity_service_name='teamcity'
	teamcity_startup_item_file="/etc/systemd/system/$teamcity_service_name.service"
	teamcity_start_script="$teamcity_control_scripts_path/teamcity_start.sh"
	teamcity_stop_script="$teamcity_control_scripts_path/teamcity_stop.sh"
	teamcity_log_file="/var/log/$teamcity_service_name.log"
	teamcity_pid_file="$teamcity_pids_folder/teamcity.pid"
	teamcity_port=8111

#Teamcity Agent
	teamcity_agent_service_name='teamcity_agent'
	teamcity_agent_startup_item_file="/etc/systemd/system/$teamcity_agent_service_name.service"
	teamcity_agent_start_script="$teamcity_installation_path/control_scripts/teamcity_agent_start.sh"
	teamcity_agent_stop_script="$teamcity_installation_path/control_scripts/teamcity_agent_stop.sh"
	teamcity_agent_log_file="/var/log/$teamcity_agent_service_name.log"
	teamcity_agent_pid_file="$teamcity_agent_installation_path/logs/buildAgent.pid"

try_n_times_to_get_url()
{
	local n_tries=$1
	local url=$2

	local counter=0

	wget --progress=bar:force $url
	download_result=$?
	while [ "$download_result" -ne "0" ] && [ $counter -lt $n_tries ]
	do
		sleep 1
		counter=$(( $counter + 1 ))
		info "Network request failed. Retry No. $counter. Will retry until the try No. $n_tries. This is NORMAL as the TeamCity Server may be booting up!"
		wget --progress=bar:force $url
		download_result=$?
	done

	if [ $counter -eq $n_tries ] && [ "$download_result" -ne "0" ]
	then
		return 1
	else
		return 0
	fi
}
