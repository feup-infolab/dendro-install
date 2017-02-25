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

info "Installing Jenkins..."

echo $(pwd)

#install oracle jdk 8
source ./Dependencies/oracle_jdk8.sh &&

#install jenkins
sudo wget -q -O - https://pkg.jenkins.io/debian/jenkins-ci.org.key | sudo apt-key add - &&
sudo sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list' &&
sudo apt-get update &&
sudo apt-get -y install jenkins ||
die "Failed to install Jenkins."

IFS='%'
read -r -d '' old_line << LUCHI
HTTP_PORT=8080
LUCHI
unset IFS

IFS='%'
read -r -d '' new_line << LUCHI
HTTP_PORT=$jenkins_port
LUCHI
unset IFS

patch_file $jenkins_conf_file "$old_line" "$new_line" "jenkins_port_patch" "sh" && success "Patched hostname $host to 127.0.0.1." || die "Unable to patch Jenkins port at "

sudo service jenkins restart
password=$(sudo cat /var/lib/jenkins/secrets/initialAdminPassword)
success "Installed Jenkins. Your initial Admin password is $password. "

#go back to initial dir
cd $setup_dir || die "Unable to return to starting directory during Jenkins Setup."
