#!/usr/bin/env bash

if [ -z ${DIR+x} ]; then
	#running by itself
	source ../constants.sh
else
	#running from dendro_full_setup_ubuntu_server_ubuntu_16.sh
	source ./constants.sh
fi

info "Installing Virtuoso from .deb @feup-infolab/virtuoso7-debs."

#save current dir
setup_dir=$(pwd)

#install git lfs
sudo apt-get install software-properties-common &&
sudo add-apt-repository -y ppa:git-core/ppa &&
curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | sudo bash &&
sudo apt-get update &&
sudo apt-get install git-lfs && info "Installed git lfs" || die "Unable to install Git lfs!"

#stop virtuoso service if running
sudo service virtuoso stop

#install Virtuoso devel from .deb
rm -rf virtuoso7
git lfs clone https://github.com/feup-infolab/virtuoso7-debs.git virtuoso7 &&
sudo dpkg -i virtuoso7/debs-ubuntu-16-04/virtuoso_7.4.2-devel-1_amd64.deb || die "Unable to install virtuoso!"

#setup default configuration .ini file
sudo cp /usr/local/virtuoso-opensource/var/lib/virtuoso/db/virtuoso.ini.sample /usr/local/virtuoso-opensource/var/lib/virtuoso/db/virtuoso.ini

# ================================
# = Virtuoso Performance Patches =
# ================================

read -r -d '' replaced_line << LUCHI
MaxClientConnections		= 10
LUCHI

replace_text_in_file "$virtuoso_ini_path" "$replaced_line" "MaxClientConnections		= 100"  "MaxClientConnectionsDendroPatch" "ini"

read -r -d '' replaced_line << LUCHI
ServerThreads		= 10
LUCHI

replace_text_in_file "$virtuoso_ini_path" "$replaced_line" "ServerThreads			= 100"  "ServerThreadsDendroPatch" "ini"

read -r -d '' replaced_line << LUCHI
MaxKeepAlives			= 10
LUCHI

replace_text_in_file "$virtuoso_ini_path" "$replaced_line" "MaxKeepAlives			= 100"  "MaxKeepAlivesDendroPatch" "ini"

read -r -d '' replaced_line << LUCHI
NumberOfBuffers          = 10000
LUCHI

replace_text_in_file "$virtuoso_ini_path" "$replaced_line" "NumberOfBuffers          = 80000"  "NumberOfBuffersDendroPatch" "ini"

read -r -d '' replaced_line << LUCHI
MaxDirtyBuffers          = 6000
LUCHI

replace_text_in_file "$virtuoso_ini_path" "$replaced_line" "MaxDirtyBuffers          = 65000"  "MaxDirtyBuffersDendroPatch" "ini"

# ===========================================
# = create virtuoso user and give ownership =
# ===========================================
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

success "Installed Virtuoso from .deb @feup-infolab/virtuoso7-debs."
