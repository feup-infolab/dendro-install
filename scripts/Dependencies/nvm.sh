#!/usr/bin/env bash

node_version=$1

#install NVM, use node version
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.1/install.sh | bash &&
export NVM_DIR="$HOME/.nvm" &&
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  && # This loads nvm

nvm install "$node_version" &&
nvm use "$node_version" &&

#update npm
npm -g install npm@latest &&
npm cache clean &&

#install bower
npm install -g bower stylus &&

#install automatic version switching
npm install -g avn avn-nvm avn-n &&
avn setup || echo "Failed to install nvm and node!"
