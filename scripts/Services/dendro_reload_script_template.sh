#!/usr/bin/env bash

echo "[[ Dendro %DENDRO_SERVICE_NAME% reloading...]]"

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

#kill pm2 for the cases where the install folder is deleted, force to update pm2's CWD to avoid
#Cluster mode "ENOENT: no such file or directory, uv_cwd" issue. Doesn't appear to relate to symlinks. #2057
pm2 kill

#force pm2 to daemonize
pm2 list > /dev/null
pm2 status > /dev/null

#start app
npm restart

#npm start | tee --append %DENDRO_LOG_FILE%

if [[ "$?" != "0" ]]
then
	echo "There was an error restarting Dendro Service %DENDRO_SERVICE_NAME% !"
	exit 1
fi
