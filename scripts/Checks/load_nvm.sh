#!/usr/bin/env bash

node_version=$1

load_nvm()
{
  export NVM_DIR="$HOME/.nvm" &&
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" && echo "NVM loaded."
}

install_nvm()
{
  echo "Installing NVM as $(whoami) and Node version $node_version..."

  for file in "$HOME/.bash_profile" "$HOME/.zshrc" "$HOME/.profile" "$HOME/.bashrc"
  do
    if [ -f $file ]
    then
      echo "Touching $file..."
      touch "$file"
    fi
  done

  #install NVM, use node version
  curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.1/install.sh | bash > /dev/null &&
  load_nvm
}

install_node()
{
  echo "Installing node $node_version"

  nvm install "$node_version" &&
  nvm use "$node_version" || exit 1

  echo "Installed NVM and Node version $node_version successfully."

  #update npm
  npm -g install npm@latest &&
  npm cache clean || exit 1
  echo "Installed NPM"

  #install bower
  npm install -g bower stylus || exit 1
  echo "Installed Bower"

  #install automatic version switching
  npm install -g avn avn-nvm avn-n && avn setup || exit 1
  echo "Installed AVN"
}

echo "Starting NVM setup as $(whoami)..."

nvm > /dev/null 2>&1 # 2>&1 == "redirect stderr to stdout"

if [ "$?" != "0" ]
then
  #install nvm as $dendro_user_name to have node to run the dendro service as that user
  echo "NVM is not loaded for user $(whoami)."

  if [ ! -d "$HOME/.nvm" ]
  then
    echo "NVM is not installed for user $(whoami). Installing NVM as $(whoami)..."
    install_nvm
  else
    echo "User $(whoami) has nvm installed. Trying to load it..."
    load_nvm
  fi
fi

nvm > /dev/null 2>&1 # 2>&1 == "redirect stderr to stdout"

if [ "$?" == "0" ]
then
  install_node
else
  echo "[FATAL ERROR] NVM is not present even after trying to install it. Something serious happened."
  exit 1
fi

echo "NVM Setup/Activation complete!"
