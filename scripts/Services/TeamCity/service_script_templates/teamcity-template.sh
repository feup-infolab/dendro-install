#!/bin/sh
#
# /etc/init.d/teamcity -- startup script for the TeamCity server
#
# Written by João Rocha da Silva <https://github.com/silvae86>.
#
### BEGIN INIT INFO
# Provides:          %TEAMCITY_SERVICE_NAME%
# Required-Start:    $local_fs $network
# Required-Stop:     $local_fs $network
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Start PROGRAM
# Description:       Start the PROGRAM search engine platform
### END INIT INFO

#./lib/lsb/init-functions

dendro_username='%DENDRO_USERNAME%'

#teamcity
teamcity_installation_path='%TEAMCITY_INSTALLATION_PATH%'
teamcity_service_name='%TEAMCITY_SERVICE_NAME%'
teamcity_log_file='%TEAMCITY_LOG_FILE%'
teamcity_pid_file='%TEAMCITY_PID_FILE%'
teamcity_service_name='%TEAMCITY_SERVICE_NAME%'
teamcity_start_script_file='%TEAMCITY_START_SCRIPT_FILE%'

start() {
  while [ ! "$stopped" = "false" ]
  do
    echo "Monitoring TeamCity Server... PID: $pid"
    if [ "$pid" = "" ] || [ ! "$(kill -0 $pid)" ]
    then
      echo "ReStart of TeamCity Server..."
      sudo su $dendro_username /bin/sh -c "$teamcity_start_script_file" &

      pid=$(cat $teamcity_pid_file)
      if [ ! "$pid" = "" ]
      then
          echo "Grepping PID: $pid"
          ps aux | grep $pid
      fi
    fi
    sleep 1
  done

  return 0
}

#usar pgrep em outros casos

stop() {
  stopped=true
  pid=$(cat $teamcity_pid_file)

  if [ ! "$(su $dendro_username -c "(cd $teamcity_installation_path && $teamcity_installation_path/bin/teamcity-server.sh stop >> $teamcity_log_file 2>&1 )")" ]
  then
    echo "Stopped TeamCity server."
  fi

  ### Now, delete the pid file ###
  rm -f $teamcity_pid_file
  return 0
}

case "$1" in
  start)
    echo "Starting TeamCity server..."
    start
    ;;
  stop)
    echo "Stopping TeamCity server..."
    stop
    ;;
  status)
    status $teamcity_service_name
    ;;
  restart)
    echo "Restarting TeamCity server..."
    stop && start
    ;;
  *)
    echo "Usage: $0 {start|stop|restart}"
    exit 1
    ;;
esac

exit 0

# start() {
#   stopped="false"
#
#   cd $teamcity_installation_path; $teamcity_installation_path/bin/teamcity-server.sh start >> $teamcity_log_file 2>&1 &
#   pid=$!
#
#         echo "First Start of TeamCity Server...2"
#     echo "$pid"
#
#   echo "First Start of TeamCity Server..."
#
#   while [ "$stopped" = "false" ]
#   do
#     echo "First Start of TeamCity Server...1"
#     if [ ! "$(kill -0 $pid)" ]
#     then
#       echo "First Start of TeamCity Server...2"
#       su $dendro_username -c "(cd $teamcity_installation_path && $teamcity_installation_path/bin/teamcity-server.sh start >> $teamcity_log_file 2>&1 ) &"
#       pid=$!
#       #echo the pid of the service to the file
#       sudo echo $pid | tee $teamcity_pid_file
#     fi
#     sleep 1
