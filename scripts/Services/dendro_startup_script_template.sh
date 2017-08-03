#!/usr/bin/env bash

echo "[[Dendro starting...]]"
export NVM_DIR="$HOME/.nvm" &&
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
echo "nvm is at: $NVM_DIR"

nvm use %NODE_VERSION% --delete-prefix &&

echo "node is at: $(which node)"
echo "node version: $(node -v)"

node %DENDRO_INSTALLATION_PATH%/src/app.js >> %DENDRO_LOG_FILE% 2>&1
