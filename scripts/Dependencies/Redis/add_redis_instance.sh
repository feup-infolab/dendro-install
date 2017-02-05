#!/usr/bin/env bash

if [ -z ${DIR+x} ]; then
	#running by itself
	source ../../constants.sh
else
	#running from dendro_full_setup_ubuntu_server_ubuntu_16.sh
	source ./constants.sh
fi

id=$1
host=$2
port=$3

info "Setting up Redis Instance $id on host $host:$port..."
#save current dir
setup_dir=$(pwd)

#section to replace in redis service file
IFS='%'
read -r -d '' old_service_script_section << LUCHI
### BEGIN INIT INFO
# Provides:		redis-server
# Required-Start:	\$syslog \$remote_fs
# Required-Stop:	\$syslog \$remote_fs
# Should-Start:		\$local_fs
# Should-Stop:		\$local_fs
# Default-Start:	2 3 4 5
# Default-Stop:		0 1 6
# Short-Description:	redis-server - Persistent key-value db
# Description:		redis-server - Persistent key-value db
### END INIT INFO


PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
DAEMON=/usr/bin/redis-server
DAEMON_ARGS=/etc/redis/redis.conf
NAME=redis-server
DESC=redis-server

RUNDIR=/var/run/redis
PIDFILE=\$RUNDIR/redis-server.pid
LUCHI
unset IFS

#sections to replace in redis configuration file
IFS='%'
read -r -d '' old_conf_file_pid_section << LUCHI
pidfile /var/run/redis/redis-server.pid
LUCHI
unset IFS

IFS='%'
read -r -d '' old_conf_file_port_section << LUCHI
port 6379
LUCHI
unset IFS

IFS='%'
read -r -d '' old_conf_file_logfile_section << LUCHI
logfile /var/log/redis/redis-server.log
LUCHI
unset IFS

IFS='%'
read -r -d '' old_conf_file_dir_section << LUCHI
dir /var/lib/redis
LUCHI
unset IFS


setup_redis_instance()
{
  local id=$1
  local host=$2
  local port=$3
  local redis_instance_name="redis_$id_$port"
  local redis_instance_name_filename="$redis_instance_name.service"

  local new_conf_file="$redis_conf_folder/$redis_instance_name.conf"
  local new_workdir="/var/run/$redis_instance_name"
  local new_pidfile="$new_workdir/$redis_instance_name.pid"
  local new_logfile="/var/log/redis/$redis_instance_name.log"
  local new_init_script_file="/etc/init.d/$redis_instance_name"
  local new_service_file="/etc/systemd/system/$redis_instance_name_filename"

  info "Creating Redis work directory at $new_workdir."
  sudo mkdir -p $new_workdir  
  sudo chown -R redis:redis $new_workdir

  #changes to conf file
  new_conf_file_pid_section="pidfile $new_pidfile"
  new_conf_file_port_section="port $port"
  new_conf_file_logfile_section="logfile $new_logfile"
  new_conf_file_dir_section="dir $new_workdir"

  #patch configuration file
  sudo cp "$redis_conf_file" "$new_conf_file" &&
  patch_file $new_conf_file	 \
          "$old_conf_file_pid_section" \
          "$new_conf_file_pid_section" \
          "$redis_instance_name-patch-pid" &&
  patch_file $new_conf_file	 \
          "$old_conf_file_port_section" \
          "$new_conf_file_port_section" \
          "$redis_instance_name-patch-logfile" &&
  patch_file $new_conf_file	 \
          "$old_conf_file_logfile_section" \
          "$new_conf_file_logfile_section" \
          "$redis_instance_name-patch-pid" &&
  patch_file $new_conf_file	 \
          "$old_conf_file_dir_section" \
          "$new_conf_file_dir_section" \
          "$redis_instance_name-patch-pid" || die "Unable to patch Redis $id's configuration file at $new_conf_file"

  #create service file

IFS='%'
read -r -d '' new_service_contents << LUCHI
[Unit]
Description=Advanced key-value store ($redis_instance_name)
After=network.target
Documentation=http://redis.io/documentation, man:redis-server(1)

[Service]
Type=forking
ExecStart=/usr/bin/redis-server $new_conf_file
PIDFile=$new_pidfile
TimeoutStopSec=0
Restart=always
User=redis
Group=redis

ExecStartPre=-/bin/run-parts --verbose /etc/redis/redis-server.pre-up.d
ExecStartPost=-/bin/run-parts --verbose /etc/redis/redis-server.post-up.d
ExecStop=-/bin/run-parts --verbose /etc/redis/redis-server.pre-down.d
ExecStop=/bin/kill -s TERM $MAINPID
ExecStopPost=-/bin/run-parts --verbose /etc/redis/redis-server.post-down.d

PrivateTmp=yes
PrivateDevices=yes
ProtectHome=yes
ReadOnlyDirectories=/
ReadWriteDirectories=-/var/lib/redis
ReadWriteDirectories=-/var/log/redis
ReadWriteDirectories=-$new_workdir
CapabilityBoundingSet=~CAP_SYS_PTRACE

# redis-server writes its own config file when in cluster mode so we allow
# writing there (NB. ProtectSystem=true over ProtectSystem=full)
ProtectSystem=true
ReadWriteDirectories=-/etc/redis

[Install]
WantedBy=multi-user.target
Alias=$redis_instance_name.service
LUCHI
unset IFS

	if [[ -f $new_service_file ]]
	then
		sudo rm $new_service_file
	fi

	printf "%s" "$new_service_contents" | sudo tee $new_service_file

	#open this redis instance to outside connections if this VM is in dev mode...

	if [[ $set_dev_mode = "true" ]]
	then
		info "Trying to open Redis instance $redis_instance_name to ANY remote connection."
		file_exists file_exists_flag $new_conf_file
		if [[ "$file_exists_flag" == "true" ]]; then
			info "File $new_conf_file exists..."
			patch_file $new_conf_file "bind 127.0.0.1" "bind 0.0.0.0" "redis_$redis_instance_name-dendro_dev_patch"  && success "Opened Redis." || die "Unable to patch Redis $redis_instance_name configuration file at $new_conf_file."
		else
			die "File $new_conf_file does not exist."
		fi
	fi

	#reload systemctl and start service
	sudo systemctl daemon-reload
	sudo systemctl unmask $redis_instance_name_filename
	sudo systemctl enable $redis_instance_name
	sudo systemctl start $redis_instance_name_filename
}

sudo nc "$host" "$port" < /dev/null;
server_not_listening=$?

if [[ ! "$server_not_listening" = "0" ]]
then
	sudo systemctl stop $redis_instance_name > /dev/null
	setup_redis_instance $id $host $port
else
  	warning "There is already a program listening on $host:$port. Stopping configuration of Redis instance $id on $host:$port."
fi

#return to previous dir
cd $setup_dir || die "Unable to return to previous directory while settting up Redis Instance Redis instance $id on $host:$port."
