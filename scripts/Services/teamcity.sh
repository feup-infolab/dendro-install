#!/bin/sh
#
# /etc/init.d/teamcity -- startup script for the TeamCity server
#
# Written by João Rocha da Silva <https://github.com/silvae86>.
#
### BEGIN INIT INFO
# Provides:          teamcity
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
teamcity_startup_item_file="%TEAMCITY_STARTUP_ITEM_FILE%"
teamcity_log_file="%TEAMCITY_LOG_FILE%"

start() {
  su $dendro_username -c "(cd $teamcity_installation_path && $teamcity_installation_path/bin/teamcity-server.sh start >> $teamcity_log_file 2>&1 )"
  return 0
}

#usar pgrep em outros casos

stop() {
  su $dendro_username -c "(cd $teamcity_installation_path && $teamcity_installation_path/bin/teamcity-server.sh stop >> $teamcity_log_file 2>&1 )"
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
