#!/usr/bin/env bash

echo "[[ Dendro starting...]]" 

export NVM_DIR="$HOME/.nvm" &&
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm

echo "[[ nvm location: $NVM_DIR ]]"
echo "[[ node location: $(which node) ]]"
echo "[[ node version: $(node -v) ]]"
echo "[[ user running the script: $(whoami) ]]"
echo "[[ dendro installation path: %DENDRO_INSTALLATION_PATH% ]]"
echo "[[ dendro log location: %DENDRO_LOG_FILE% ]]"

nvm use %NODE_VERSION% --delete-prefix &&
pm2 list &&
pm2 kill &&
pm2 update && 
node %DENDRO_INSTALLATION_PATH%/src/app.js | tee --append %DENDRO_LOG_FILE%
	
if [[ "$?" != "0" ]]
then
	echo "There was an error starting Dendro Service!!!"
	exit 1
fi


