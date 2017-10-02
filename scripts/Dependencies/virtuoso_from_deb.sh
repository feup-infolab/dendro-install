#!/usr/bin/env bash

if [ -z ${DIR+x} ]; then
	#running by itself
	source ../constants.sh
else
	#running from dendro_full_setup_ubuntu_server_ubuntu_16.sh
	source ./constants.sh
fi

info "Installing Virtuoso 7.2.4 from .deb @feup-infolab/virtuoso7-debs."

#save current dir
setup_dir=$(pwd)

#install git lfs

sudo apt-get install software-properties-common &&
sudo add-apt-repository ppa:git-core/ppa &&
curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | sudo bash &&
sudo apt-get update &&
sudo apt-get install git-lfs && info "Installed git lfs" || die "Unable to install Git lfs!"

#install Virtuoso devel from .deb

git lfs clone https://github.com/feup-infolab/virtuoso7-debs.git virtuoso7 &&
sudo dpkg -i virtuoso7/debs-ubuntu-16-04/*stable*.deb

#setup default configuration .ini file
sudo cp /usr/local/virtuoso-opensource/var/lib/virtuoso/db/virtuoso.ini.sample /usr/local/virtuoso-opensource/var/lib/virtuoso/db/virtuoso.ini

#create virtuoso user and give ownership
sudo useradd $virtuoso_user
sudo addgroup $virtuoso_group
sudo usermod $virtuoso_user -g $virtuoso_group
echo "${virtuoso_user}:${virtuoso_user_password}" | sudo chpasswd
sudo chown -R $virtuoso_user:$virtuoso_group /usr/local/virtuoso-opensource

# Setting crontab to reboot virtuoso every day at 4am (likely has memory leaks...)

	#from http://stackoverflow.com/questions/23309120/setting-cron-task-every-day-at-2am-makes-it-run-every-minute
	# This runs the script every minute of 2am (02:00, 02:01, 02:02 and so on):
	#
	#  * 2 * * *
	#  While This runs the script at 02:13am (of each day of each month)
	#
	#  13 2 * * *
	#
	#  * * * * *  command to execute
	#  ┬ ┬ ┬ ┬ ┬
	#  │ │ │ │ │
	#  │ │ │ │ │
	#  │ │ │ │ └───── day of week (0 - 7) (0 to 6 are Sunday to Saturday, 7 is 	Sunday again)
	#  │ │ │ └────────── month (1 - 12)
	#  │ │ └─────────────── day of month (1 - 31)
	#  │ └──────────────────── hour (0 - 23)
	#  └───────────────────────── min (0 - 59)

add_line_to_file_if_not_present "00 4 * * *   root    test -x /usr/sbin/anacron || ( systemctl restart virtuoso  )" "/etc/crontab" ||
die "Failed to set Virtuoso OpenSource crontab"

#go back to initial dir
cd $setup_dir

success "Installed Virtuoso 7.2.4 from .deb @feup-infolab/virtuoso7-debs."
