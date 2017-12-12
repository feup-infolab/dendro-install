#!/usr/bin/env bash

echo "[[Dendro starting...]]"
export NVM_DIR="$HOME/.nvm" &&
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
echo "nvm is at: $NVM_DIR"

nvm use %NODE_VERSION% --delete-prefix &&

echo "node is at: $(which node)"
echo "node version: $(node -v)"

pm2 list
node src/app.js | tee --append %DENDRO_LOG_FILE%
	
if [[ "$?" != "0" ]]
then
	exit 1
fi

#node %DENDRO_INSTALLATION_PATH%/src/app.js 
