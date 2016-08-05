#!/usr/bin/env bash

if [ -z ${DIR+x} ]; then 
	#running by itself
	source ../constants.sh
else 
	#running from dendro_full_setup_ubuntu_server_ubuntu_16.sh
	source ./constants.sh
fi

printf "${Cyan}[INFO]${Color_Off} Installing OpenLink Virtuoso 7......\n"

#save current dir
setup_dir=$(pwd)

#stop virtuoso server if running
sudo systemctl stop virtuoso

#install virtuoso opensource 7
cd $temp_downloads_folder
sudo rm -rf virtuoso-opensource
sudo git clone https://github.com/openlink/virtuoso-opensource.git virtuoso-opensource
cd virtuoso-opensource
sudo git branch remotes/origin/develop/7
sudo ./autogen.sh
CFLAGS="-O2 -m64"
export CFLAGS
sudo ./configure #> /dev/null 2>&1
sudo make --silent #> /dev/null 2>&1
sudo make install #--silent /dev/null 2>&1

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

add_line_to_file_if_not_present "00 4 * * *   root    test -x /usr/sbin/anacron || ( systemctl restart virtuoso  )" "/etc/crontab"


printf "${Green}[OK]${Color_Off} Installed OpenLink Virtuoso 7.\n"

#go back to initial dir
cd $setup_dir

