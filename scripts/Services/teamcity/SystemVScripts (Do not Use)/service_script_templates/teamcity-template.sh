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

#TODO
#install crontab for auto restart of service
#in case there is a problem
#**ONLY THIS** worked... yes I tried systemd after upstart
#was deprecated and it fails miserably in some circumstances.
#If you have a better idea please make a pull request...
#god give me back my hours wasted (O_o) :'-( (x_X)

run_command="^.*/etc/init.d/$teamcity_service_name$"
crontab_command="* * * * * root /etc/init.d/teamcity"

start() {
  start-stop-daemon \
    --quiet \
    --exec "$teamcity_installation_path/bin/teamcity-server.sh" \
    --pidfile $teamcity_pid_file \
    --chuid $dendro_username \
    --make-pidfile \
    --start \
    --remove-pidfile \
    -- start >> $teamcity_log_file
  RETVAL=$?

  ( crontab -l | grep -v -F "$run_command" ; echo "$crontab_command" ) | crontab -
}

#usar pgrep em outros casos
stop() {
  start-stop-daemon \
      --quiet \
      --exec "$teamcity_installation_path/bin/teamcity-server.sh" \
      --pidfile $teamcity_pid_file \
      --chuid $dendro_username \
      --make-pidfile \
      --stop \
      --remove-pidfile \
      -- stop >> $teamcity_log_file
    RETVAL=$?

    #-F matches the string exactly without expanding regex.
    ( crontab -l | grep -v -F "$run_command" ) | crontab -
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
  restart | reload | force-reload )
    echo "Restarting TeamCity server..."
    stop && start
    ;;
  *)
    echo "Usage: $0 {start|stop|restart}"
    exit 1
    ;;
esac

exit 0
