#!/usr/bin/env bash

#install node 6.x
curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash - || die "Unable to install NodeJS 6.x."
sudo apt-get install nodejs
sudo ln -s "$(which nodejs)" /usr/bin/node
