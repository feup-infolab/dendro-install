#!/usr/bin/env bash

# =================
# = Injected vars =
# =================

NODE_VERSION="%NODE_VERSION%"
DENDRO_SERVICE_NAME="%DENDRO_SERVICE_NAME%"
DENDRO_INSTALLATION_PATH="%DENDRO_INSTALLATION_PATH%"
DENDRO_LOG_FILE="%DENDRO_LOG_FILE%"

echo "[[ Dendro $DENDRO_SERVICE_NAME starting...]]" 

# ============
# = load nvm =
# ============
export NVM_DIR="$HOME/.nvm" &&
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm

nvm use "$NODE_VERSION" || nvm install "$NODE_VERSION"  && nvm use "$NODE_VERSION"

# ============
# = load avn =
# ============

#commented for debug
#[[ -s "$HOME/.avn/bin/avn.sh" ]] && source "$HOME/.avn/bin/avn.sh" && # load avn

# ==========
# = Status =
# ==========

echo "[[ nvm location: $NVM_DIR ]]"
echo "[[ node location: $(which node) ]]"
echo "[[ node version: $(node -v) ]]"
echo "[[ user running the script: $(whoami) ]]"
echo "[[ dendro installation path: $DENDRO_INSTALLATION_PATH ]]"
echo "[[ dendro log location: $DENDRO_LOG_FILE ]]"

# =============
# = start app =
# =============

cd "$DENDRO_INSTALLATION_PATH"
pm2 status > /dev/null || npm install -g pm2 && pm2 status
pm2 kill 
npm run start

if [[ "$?" != "0" ]]
then
	echo "There was an error starting Dendro Service $DENDRO_SERVICE_NAME !"
	exit 1
fi


