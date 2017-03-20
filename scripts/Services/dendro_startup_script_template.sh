#!/usr/bin/env bash

export NVM_DIR="$HOME/.nvm" &&
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  && # This loads nvm
nvm use $node_version && nodejs DENDRO_INSTALLATION_PATH/src/app.js >> DENDRO_LOG_FILE 2>&1
