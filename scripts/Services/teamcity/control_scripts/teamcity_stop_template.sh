#!/usr/bin/env bash

#teamcity
teamcity_installation_path='%TEAMCITY_INSTALLATION_PATH%'
teamcity_log_file='%TEAMCITY_LOG_FILE%'

eval "$teamcity_installation_path/bin/teamcity-server.sh stop >> $teamcity_log_file"
