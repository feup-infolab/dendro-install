#!/usr/bin/env bash

if [ -z ${DIR+x} ]; then
	#running by itself
	source ../constants.sh
else
	#running from dendro_full_setup_ubuntu_server_ubuntu_16.sh
	source ./constants.sh
fi

info "Setting up Dendro service...\n"

#save current dir
setup_dir=$(pwd)

#stop current recommender service if present
info "Stopping $dendro_service_name service..."
sudo systemctl stop $dendro_service_name > /dev/null

#setup auto-start dendro service
sudo rm -rf $dendro_startup_item_file
sudo touch $dendro_startup_item_file
sudo chmod 0655 $dendro_startup_item_file

#create startup scripts folder...
sudo mkdir -p "$dendro_startup_scripts_path"

printf "Dendro Running Service Command:"
printf "\n"
printf "$dendro_startup_script"
printf "\n"

#build startup script file
sudo rm -rf $dendro_startup_script &&
sudo cp $setup_dir/Services/dendro_startup_script_template.sh $dendro_startup_script &&
sudo sed -i "s;%DENDRO_INSTALLATION_PATH%;$dendro_installation_path;g" $dendro_startup_script &&
sudo sed -i "s;%DENDRO_LOG_FILE%;$dendro_log_file;g" $dendro_startup_script &&
sudo sed -i "s;%NODE_VERSION%;$node_version;g" $dendro_startup_script || die "Unable to build the startup script at $dendro_startup_scripts_path"

#restore ownership of the startup files to dendro user
sudo chown -R $dendro_user_name:$dendro_user_group $dendro_startup_scripts_path &&
sudo chmod +x $dendro_startup_script || die "Unable to change permissions of the startup script at $dendro_startup_scripts_path"

printf "[Unit]
Description=Dendro ${active_deployment_setting} daemon
[Service]
Type=simple
WorkingDirectory=$dendro_installation_path
Restart=on-failure
RestartSec=5s
TimeoutStartSec=infinity
User=$dendro_user_name
Group=$dendro_user_group
RuntimeMaxSec=infinity
KillMode=control-group
ExecStart=$dendro_startup_script
PIDFile=${dendro_installation_path}/running.pid
[Install]
WantedBy=multi-user.target\n" | sudo tee $dendro_startup_item_file

sudo chmod 0655 $dendro_startup_item_file
sudo systemctl daemon-reload
sudo systemctl reload
sudo systemctl enable $dendro_service_name
sudo systemctl start $dendro_service_name

timeout=10
echo "Waiting to start Dendro service... please wait $timeout seconds..."

for (( i = 0; i < $timeout; i++ )); do
	echo -ne $[$timeout-i]...
	sleep 1s
done

sudo systemctl restart $dendro_service_name

#go back to initial dir
cd $setup_dir || die "Error returning to setup folder"

success "Finished setting up Dendro service.\n"
