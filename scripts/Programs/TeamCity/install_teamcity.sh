#!/usr/bin/env bash

if [ -z ${DIR+x} ]; then
	#running by itself
	source ../../constants.sh
else
	#running from dendro_full_setup_ubuntu_server_ubuntu_16.sh
	source ./constants.sh
fi

#save current dir
setup_dir=$(pwd) &&

info "Installing TeamCity by JetBrains..."

#install oracle jdk 8
source ./Dependencies/oracle_jdk8.sh &&

#create dendro user
source ./Programs/create_dendro_user.sh &&

#install TeamCity

teamcity_package="$HOME/TeamCity.tar.gz"
teamcity_unpackage_destination="$HOME"

if [ ! -f $teamcity_package ]
then
	info "TeamCity download has not been done before. Starting download..."
	sudo wget --progress=bar:force $teamcity_url -O $teamcity_package || die "Unable to download TeamCity."
else
	info "TeamCity download present. Performing MD5 check..."
	md5=$(md5sum < $teamcity_package | cut -f1 -d' ')

	if [[ ! "$md5" == "$teamcity_md5" ]]
	then
		warning "MD5 incorrect! Need to re-download the TeamCity setup package."
		sudo rm -rf $teamcity_package
		sudo wget --progress=bar:force $teamcity_url -O $teamcity_package || die "Unable to download TeamCity."
	else
		info "MD5 correct, continuing setup without downloading."
	fi
fi

sudo tar xfz $teamcity_package -C $teamcity_unpackage_destination|| die "Unable to extract TeamCity package"

sudo rm -rf $teamcity_installation_path &&
sudo mkdir -p $teamcity_installation_path &&
sudo mv $teamcity_unpackage_destination/TeamCity/* $teamcity_installation_path &&

IFS='%'
read -r -d '' old_line << LUCHI
    <Connector port="8111" protocol="org.apache.coyote.http11.Http11NioProtocol"
               connectionTimeout="60000"
               redirectPort="8543"
               useBodyEncodingForURI="true"
               socket.txBufSize="64000"
               socket.rxBufSize="64000"
               tcpNoDelay="1"
        />
LUCHI
unset IFS

IFS='%'
read -r -d '' new_line << LUCHI
    <Connector port="3001" protocol="org.apache.coyote.http11.Http11NioProtocol"
               connectionTimeout="60000"
               redirectPort="8543"
               useBodyEncodingForURI="true"
               socket.txBufSize="64000"
               socket.rxBufSize="64000"
               tcpNoDelay="1"
        />
LUCHI
unset IFS

patch_file 	"$teamcity_installation_path/conf/server.xml" \
				"$old_line" \
				"$new_line" \
				'teamcity_patch_dendro_build_server_port' &&

sudo mkdir -p $teamcity_installation_path/logs &&
sudo cp -R Services/TeamCity/control_scripts $teamcity_installation_path &&
sudo chown -R $dendro_user_name:$dendro_user_group $teamcity_installation_path &&
sudo chmod -R ug+w $teamcity_installation_path || die "An error occurred while installing the TeamCity Server."

#go back to initial dir
cd $setup_dir || die "Unable to return to starting directory during TeamCity Setup."
