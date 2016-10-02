#!/usr/bin/env bash

if [ -z ${DIR+x} ]; then 
	#running by itself
	source ../constants.sh
else 
	#running from dendro_full_setup_ubuntu_server_ubuntu_16.sh
	source ./constants.sh
fi

printf "${Cyan}[INFO]${Color_Off} Setting up Dendro Recommender service...\n"

#save current dir
setup_dir=$(pwd)

#setup auto-start dendro recommender service

sudo rm -rf $dendro_recommender_startup_item_file
sudo touch $dendro_recommender_startup_item_file
sudo chmod 0655 $dendro_recommender_startup_item_file

#create pids folder...
sudo mkdir -p $dendro_installation_path/service_pids

printf "Recommender Running Service Command:"
printf "\n"
printf "/bin/sh -c '${dendro_recommender_install_path}/bin/recommender -Dhttp.port=${dendro_recommender_port} | tee ${dendro_recommender_log_file}"
printf "\n"

printf "[Unit]
Description=Dendro recommender daemon ${active_deployment_setting}
[Service]
Type=simple
Restart=on-failure
RestartSec=5s
RuntimeMaxSec=infinity
TimeoutStartSec=infinity
User=${dendro_user_name}
Group=${dendro_user_group}
WorkingDirectory=${dendro_recommender_install_path}
KillMode=control-group
ExecStart=/bin/sh -c '${dendro_recommender_install_path}/bin/recommender -Dconfig.file=${dendro_recommender_install_path}/conf/application.conf -Dhttp.port=${dendro_recommender_port} | tee ${dendro_recommender_log_file}'
PIDFile=$installation_path/service_pids/${dendro_recommender_service_name}
[Install]
WantedBy=multi-user.target\n" | sudo tee $dendro_recommender_startup_item_file

sudo chmod 0655 $dendro_recommender_startup_item_file
sudo systemctl daemon-reload
sudo systemctl reload
sudo systemctl enable $dendro_recommender_service_name
sudo systemctl start $dendro_recommender_service_name

#go back to initial dir
cd $setup_dir

printf "${Green}[OK]${Color_Off} Finished setting up Dendro Recommender service.\n"

#SCRAP
#kill processes on a given port
#lsof -i tcp:${dendro_recommender_port} | awk 'NR!=1 {print $2}' | xargs kill
