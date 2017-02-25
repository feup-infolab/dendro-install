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

#user exists?
id -u $jenkins_user > /dev/null

if [[ "$?" -eq "1" ]]; then
	sudo useradd $jenkins_user || die "Failed to create user ${dendro_user_name}."
else
	info "User ${jenkins_user} already exists, no need to create it again."
fi

#create jenkins user
sudo addgroup $jenkins_user_group
sudo usermod $jenkins_user -g $jenkins_user_group
echo "${jenkins_user}:${jenkins_user_password}" | sudo chpasswd

#add jenkins to sudoers
sudo usermod -aG sudo "${jenkins_user}"

#install jenkins
sudo wget -q -O - https://pkg.jenkins.io/debian/jenkins-ci.org.key | sudo apt-key add - &&
sudo sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list' &&
sudo apt-get update &&
sudo apt-get -y install jenkins ||
die "Failed to install Jenkins."

#change ownership of jenkins to the user we want it to run Underline
sudo chown -R $jenkins_user:$jenkins_user_group /var/lib/jenkins
sudo chown -R $jenkins_user:$jenkins_user_group /var/cache/jenkins
sudo chown -R $jenkins_user:$jenkins_user_group /var/log/jenkins

#patch Jenkins config to run as our user

sudo sed -i "s/JENKINS_USER=jenkins/JENKINS_USER=$jenkins_user/g" $jenkins_config_file &&
sudo sed -i "s/HTTP_PORT=8080/HTTP_PORT=$jenkins_port/g" $jenkins_config_file && success "Set jenkins user and group." || die "Unable to patch Jenkins file at $jenkins_config_file."

#restart jenkins
sudo /etc/init.d/jenkins restart
sudo ps -ef | grep jenkins

#echo initial password
password=$(sudo cat /var/lib/jenkins/secrets/initialAdminPassword)
success "Installed Jenkins. Your initial Admin password is $password. "

#go back to initial dir
cd $setup_dir || die "Unable to return to starting directory during Jenkins Setup."
