#!/usr/bin/env bash

node_version=$1

load_nvm()
{
  export NVM_DIR="$HOME/.nvm" &&
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" && echo "NVM loaded."
}

add_line_at_end_of_file_if_tag_not_present()
{
	local file=$1
	local new_line=$2
	local tag=$3
	grep -q -F "####$tag" $file || echo "$new_line   ####$tag" >> $file
}

#commented for debug
#append_nvm_and_avn_to_profile()
# {
#   add_line_at_end_of_file_if_tag_not_present ~/.bash_profile 'export NVM_DIR="$HOME/.nvm" &&' 'NVM_LOAD_1'
#   add_line_at_end_of_file_if_tag_not_present ~/.bash_profile '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" && echo "NVM loaded."' 'NVM_LOAD_2'
#   add_line_at_end_of_file_if_tag_not_present ~/.bash_profile '[[ -s "$HOME/.avn/bin/avn.sh" ]] && source "$HOME/.avn/bin/avn.sh" # load avn' 'AVN_LOAD_1'
# }

install_nvm()
{
  echo "Installing NVM as $(whoami) and Node version $node_version..."

  declare -a files=("$HOME/.bash_profile" "$HOME/.zshrc" "$HOME/.profile" "$HOME/.bashrc")
  for file in "${files[@]}"
  do
    if [ ! -f $file ]
    then
      echo "Touching $file..."
      touch "$file"
    fi
  done

  #install NVM, use node version
  curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.2/install.sh | bash > /dev/null &&
  load_nvm
}

install_node()
{
  echo "Installing node $node_version"

  nvm install "$node_version" &&
  nvm use "$node_version" --delete-prefix || exit 1

  echo "Installed NVM and Node version $node_version successfully as $(whoami)."

  #install npm
  npm > /dev/null 2>&1
  if [ "$?" != "0" ]
  then
    npm -g install npm@latest || exit 1
    echo "Installed NPM as $(whoami)"
  else
    echo "User $(whoami) already has NPM installed."
  fi

  #install bower
  bower > /dev/null 2>&1
  if [ "$?" != "0" ]
  then
    npm install -g bower || exit 1
    echo "Installed Bower as $(whoami)"
  else
    echo "User $(whoami) already has Bower installed."
  fi

  #commented for debug
  #install automatic version switching
  #avn > /dev/null 2>&1
  #if [ "$?" != "0" ]
  #then
  #  npm install -g avn avn-nvm avn-n && avn setup || exit 1
  #  echo "Installed AVN as $(whoami)"
  #else
  #  echo "User $(whoami) already has AVN installed."
  #fi

  #append_nvm_and_avn_to_profile
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
  echo "[FATAL ERROR] NVM is not present even after trying to install it as $(whoami). Something serious happened."
  exit 1
fi

echo "NVM Setup/Activation complete as $(whoami)."
