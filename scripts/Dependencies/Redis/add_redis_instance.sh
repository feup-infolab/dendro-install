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

  local new_conf_file="$redis_conf_folder/redis-$id-$port.conf"
  local new_workdir="/var/run/redis-$id-$port"
  local new_pidfile="/var/run/redis-$id-$port/redis-$id-$port.pid"
  local new_logfile="/var/log/redis/redis-$id-$port.log"
  local new_init_script_file="/etc/init.d/redis-$id-$port"

  if [ ! -d $new_workdir ]
  then
    mkdir -p $new_workdir
  fi

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
          "redis-$id-$port-patch-pid" &&
  patch_file $new_conf_file	 \
          "$old_conf_file_port_section" \
          "$new_conf_file_port_section" \
          "redis-$id-$port-patch-logfile" &&
  patch_file $new_conf_file	 \
          "$old_conf_file_logfile_section" \
          "$new_conf_file_logfile_section" \
          "redis-$id-$port-patch-pid" &&
  patch_file $new_conf_file	 \
          "$old_conf_file_dir_section" \
          "$new_conf_file_dir_section" \
          "redis-$id-$port-patch-pid" || die "Unable to patch Redis $id's configuration file at $new_conf_file"

  #patch init script for new redis instance
IFS='%'
read -r -d '' new_service_script_section << LUCHI
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
DAEMON=$new_init_script_file
DAEMON_ARGS=$new_conf_file
NAME=$id
DESC=$id

RUNDIR=$new_workdir
PIDFILE=$new_pidfile
LUCHI
unset IFS


echo $old_service_script_section
echo "\n\n"
echo $new_service_script_section

  sudo cp "$redis_init_script_file" "$new_init_script_file" &&
  patch_file $new_conf_file	 \
          "$old_conf_file_logfile_section" \
          "$new_conf_file_logfile_section" \
          "redis-$id-$port-patch-configuration-file" || die "Unable to patch the Configuration file for Redis Redis instance $id on $host:$port."

  #start new service
  echo "$new_init_script_file start"
}

sudo nc "$host" "$port" < /dev/null;
server_not_listening=$?

if [[ "$server_not_listening" -ne "0" ]]
then
  setup_redis_instance $id $host $port
else
  warning "There is already a program listening on $host:$port. Stopping configuration of Redis instance $id on $host:$port."
fi

#return to previous dir
cd $setup_dir || die "Unable to return to previous directory while settting up Redis Instance Redis instance $id on $host:$port."
