#!/usr/bin/env bash

IFS='%'
read -r -d '' old_line << LUCHI
#
# Instead of skip-networking the default is now to listen only on
# localhost which is more compatible and is not less secure.
bind-address		= 127.0.0.1
LUCHI
unset IFS

IFS='%'
read -r -d '' new_line << LUCHI
#
# Instead of skip-networking the default is now to listen only on
# localhost which is more compatible and is not less secure.
#bind-address		= 127.0.0.1
LUCHI
unset IFS

file="/Users/joaorocha/Desktop/mysqld.cnf"

replacement_text=$(/usr/local/bin/nodejs replace.js "$old_line" "$new_line" "$file")

echo "$replacement_text"
