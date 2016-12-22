#!/usr/bin/env bash

source scripts/constants.sh

IFS='%'
read -r -d '' old_line << LUCHI
    <Connector port="8111" protocol="org.apache.coyote.http11.Http11NioProtocol"
               connectionTimeout="60000"
               redirectPort="8543"
               useBodyEncodingForURI="true"
               socket.txBufSize="64000"
               socket.rxBufSize="64000"
               tcpNoDelay="1"
        />
LUCHI
unset IFS

IFS='%'
read -r -d '' new_line << LUCHI
    <Connector port="3001" protocol="org.apache.coyote.http11.Http11NioProtocol"
               connectionTimeout="60000"
               redirectPort="8543"
               useBodyEncodingForURI="true"
               socket.txBufSize="64000"
               socket.rxBufSize="64000"
               tcpNoDelay="1"
        />
LUCHI
unset IFS

file="/Users/joaorocha/Desktop/server.xml"

replacement_text=$(/usr/local/bin/node replace.js "$old_line" "$new_line" "$file")

echo "$replacement_text"
