#!/bin/sh
#
# /etc/init.d/teamcity_agent -- startup script for the TeamCity server
#
# Written by João Rocha da Silva <https://github.com/silvae86>.
#
### BEGIN INIT INFO
# Provides:          %TEAMCITY_AGENT_SERVICE_NAME%
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
teamcity_agent_installation_path='%TEAMCITY_AGENT_INSTALLATION_PATH%'
teamcity_agent_service_name='%TEAMCITY_AGENT_SERVICE_NAME%'
teamcity_agent_startup_item_file='%TEAMCITY_AGENT_STARTUP_ITEM_FILE%'
teamcity_agent_agent_log_file='%TEAMCITY_AGENT_LOG_FILE%'
teamcity_agent_pid_file="%TEAMCITY_AGENT_PID_FILE%"

start() {
  su $dendro_username -c "(cd $teamcity_agent_installation_path && $teamcity_agent_installation_path/bin/agent.sh start >> $teamcity_agent_log_file 2>&1 ) &"
  sudo echo $! | tee $teamcity_pid_file
  return 0
}

#usar pgrep em outros casos

stop() {
  su $dendro_username -c "(cd $teamcity_agent_installation_path && $teamcity_agent_installation_path/buildAgent/bin/agent.sh stop >> $teamcity_agent_log_file 2>&1 )"
  return 0
}

case "$1" in
  start)
    echo "Starting TeamCity Agent..."
    start
    ;;
  stop)
    echo "Stopping TeamCity Agent..."
    stop
    ;;
  restart)
    echo "Restarting TeamCity Agent..."
    stop && start
    ;;
  *)
    echo "Usage: $0 {start|stop|restart}"
    exit 1
    ;;
esac

exit 0
