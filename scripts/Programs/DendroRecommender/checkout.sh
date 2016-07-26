#!/usr/bin/env bash

if [ -z ${DIR+x} ]; then 
	#running by itself
	source ../../constants.sh
else 
	#running from dendro_full_setup_ubuntu_server_ubuntu_16.sh
	source ./constants.sh
fi

#save current dir
setup_dir=$(pwd)

#stop current recommender service if present
echo "[INFO] Stopping ${dendro_recommender_service_name} service..."
sudo systemctl stop $dendro_recommender_service_name

#check out dendro recommender code from svn repo
echo "[INFO] Installing Dendro Recommender to path : ${dendro_recommender_install_path}"
sudo rm -rf $dendro_recommender_install_path
cd $temp_downloads_folder

echo "[INFO] Checking out Dendro Recommender from SVN to path : ${dendro_recommender_install_path}. PLEASE STAND BY!"
sudo svn -q export $dendro_recommender_svn_url $dendro_recommender_install_path --username $svn_user --password $svn_user_password --force

#compile program
cd $dendro_recommender_install_path

#compile program
sudo $play_framework_install_path/play compile
sudo $play_framework_install_path/play clean stage

cd ./target/universal/stage

#install compiled, standalone app to final destination
MYID="U$(date +%s)"
temp_folder_for_compiled_recommender=/tmp/$MYID

sudo mkdir -p $temp_folder_for_compiled_recommender
sudo cp -R * $temp_folder_for_compiled_recommender
sudo rm -rf $dendro_recommender_install_path/*

cd $temp_folder_for_compiled_recommender
sudo cp -R * $dendro_recommender_install_path
sudo rm -rf $temp_folder_for_compiled_recommender

#give dendro user ownership of the installation, now compiled
sudo chown -R $dendro_user_name:$dendro_user_group $recommender_installation_path
sudo chmod -R 0755 $dendro_recommender_install_path

#go back to initial dir
cd $setup_dir

