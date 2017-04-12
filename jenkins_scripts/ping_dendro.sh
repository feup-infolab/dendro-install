#!/usr/bin/env bash

timeout=$1
dendro_url=$2

for (( i = 0; i < $timeout; i++ )); do
  echo -ne "CURLing $dendro_url. Try No. $[$timeout-i]..."
  curl -sSf "$dendro_url --connect-timeout 1"
  if [ "$?" == "0" ]
  then
    exit 0
  fi
  sleep 1s
done

exit 1
