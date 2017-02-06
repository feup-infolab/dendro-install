#!/usr/bin/env bash

new_init_script_file="/etc/init.d/$redis_instance_name"

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

#patch init script for new redis instance
IFS='%'
read -r -d '' new_service_script_section << LUCHI
### BEGIN INIT INFO
# Provides:		$redis_instance_name
# Required-Start:	\$syslog \$remote_fs
# Required-Stop:	\$syslog \$remote_fs
# Should-Start:		\$local_fs
# Should-Stop:		\$local_fs
# Default-Start:	2 3 4 5
# Default-Stop:		0 1 6
# Short-Description:	$redis_instance_name - Persistent key-value db
# Description:		$redis_instance_name - Persistent key-value db
### END INIT INFO


PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
DAEMON=$new_init_script_file
DAEMON_ARGS=$new_conf_file
NAME=$new_init_script_file
DESC=$new_init_script_file

mkdir -p $new_workdir
chown -R redis:redis $new_workdir

RUNDIR=$new_workdir
PIDFILE=$new_pidfile
LUCHI
unset IFS

  printf "$old_service_script_section"
  printf "\n\n"
  printf "$new_service_script_section"

  sudo cp "$redis_init_script_file" "$new_init_script_file" &&
  patch_file $new_init_script_file	 \
          "$old_service_script_section" \
          "$new_service_script_section" \
          "$redis_instance_name-patch-service-file" \
					"sh" \
	|| die "Unable to patch the Configuration file for Redis instance $id on $host:$port."

	#fix the line endings
	sudo apt-get install --yes dos2unix &&
	sudo dos2unix $new_init_script_file || die "Unable to convert the file into Unix Line endings."

	#mark file as executable
	chmod +x $new_init_script_file
