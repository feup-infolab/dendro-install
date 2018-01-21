#!/usr/bin/env bash

echo "[[ Dendro %DENDRO_SERVICE_NAME% stopping...]]"

# =====================================================
# = load nvm, run service with the right node version =
# =====================================================

export NVM_DIR="$HOME/.nvm" &&
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm

nvm use "%NODE_VERSION%"

echo "[[ nvm location: $NVM_DIR ]]"
echo "[[ node location: $(which node) ]]"
echo "[[ node version: $(node -v) ]]"
echo "[[ user running the script: $(whoami) ]]"
echo "[[ dendro installation path: %DENDRO_INSTALLATION_PATH% ]]"
echo "[[ dendro log location: %DENDRO_LOG_FILE% ]]"

# ============
# = stop app =
# ============
cd %DENDRO_INSTALLATION_PATH%

#stop app
npm stop > %DENDRO_LOG_FILE%

if [[ "$?" != "0" ]]
then
	echo "There was an error stopping Dendro Service %DENDRO_SERVICE_NAME% !"
	exit 1
fi
