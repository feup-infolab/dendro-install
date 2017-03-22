#!/usr/bin/env bash

node_version=$1

echo "Installing NVM and Node version $node_version..."

#install NVM, use node version
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.1/install.sh > /dev/null | bash > /dev/null &&
export NVM_DIR="$HOME/.nvm" > /dev/null &&
[ -s "$NVM_DIR/nvm.sh" ] > /dev/null && \. "$NVM_DIR/nvm.sh" > /dev/null && # This loads nvm

nvm install "$node_version" > /dev/null &&
nvm use "$node_version" > /dev/null &&

#echo "LOL"

#update npm
npm -g install npm@latest &&
npm cache clean &&

#install bower
npm install -g bower stylus &&

#install automatic version switching
npm install -g avn avn-nvm avn-n &&
avn setup || echo "Failed to install nvm and node!"

echo "Installed NVM and Node version $node_version successfully."
