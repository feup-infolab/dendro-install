#!/bin/sh

die() {
  message=$1
  printf $message
  exit 1
}

dendro_username='%DENDRO_USERNAME%'

teamcity_installation_path='%TEAMCITY_INSTALLATION_PATH%'
teamcity_log_file='%TEAMCITY_LOG_FILE%'
teamcity_pid_file='%TEAMCITY_PID_FILE%'

whoami >> /tmp/whoami.txt

if [ ! -f  $teamcity_pid_file ]
then
  echo "Cannot stop TeamCity because it is not running. There is no PID file at $teamcity_pid_file?"
else
  pid=$(cat $teamcity_pid_file)
  su $dendro_username /bin/bash -c "$teamcity_installation_path/bin/teamcity-server.sh stop >> $teamcity_log_file > /dev/null 2>&1 & echo $! > $teamcity_pid_file" || die "Unable to stop TeamCity."
fi

# su joaorocha \
# "cd /Users/joaorocha/Desktop; /bin/bash -c \
# "exec "echo $(pwd) >> /Users/joaorocha/Desktop/pwd.txt"  &&
# exec "yes >> testes.txt > /dev/null 2>&1" & echo $! > /Users/joaorocha/Desktop/yes.pid""

#su joaorocha "cd /Users/joaorocha/Desktop; /bin/bash -c "exec "echo $(pwd) >> /Users/joaorocha/Desktop/pwd.txt"  && exec "yes >> testes.txt > /dev/null 2>&1" & echo $! > /Users/joaorocha/Desktop/yes.pid""
