#!/usr/bin/env bash

echo "[[ Dendro %DENDRO_SERVICE_NAME% stopping...]]"

export NVM_DIR="$HOME/.nvm" &&
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm

[[ -s "$HOME/.avn/bin/avn.sh" ]] && source "$HOME/.avn/bin/avn.sh" # load avn

echo "[[ nvm location: $NVM_DIR ]]"
echo "[[ node location: $(which node) ]]"
echo "[[ node version: $(node -v) ]]"
echo "[[ user running the script: $(whoami) ]]"
echo "[[ dendro installation path: %DENDRO_INSTALLATION_PATH% ]]"
echo "[[ dendro log location: %DENDRO_LOG_FILE% ]]"

#force avn to load version
CWD=$(pwd)
cd /
cd "$CWD"

#activate right node version
nvm use %NODE_VERSION%

#stop app
npm stop

#npm start | tee --append %DENDRO_LOG_FILE%

if [[ "$?" != "0" ]]
then
	echo "There was an error stopping Dendro Service %DENDRO_SERVICE_NAME% !"
	exit 1
fi
