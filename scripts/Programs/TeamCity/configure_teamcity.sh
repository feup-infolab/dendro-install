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

info "Configuring TeamCity..."

#get Session Cookie
rm -f $teamcity_cookies_file

try_n_times_to_get_url \
	60 \
	"http://$host:$teamcity_port/mnt"

if  [ "$?" -eq "1" ]
then
	die "TeamCity is not running :("
else
	info "TeamCity is running!"
fi

curl -c "$teamcity_cookies_file" "http://$host:$teamcity_port/mnt" || die "Unable to fetch cookie from TeamCity server."

info "Fetched TeamCity cookie..."

#First configuration page...

curl "http://$host:$teamcity_port/mnt/do/saveUserInputOnDBsettingsPage"
	-H "Origin: http://$host:$teamcity_port"
	-H 'Accept-Encoding: gzip, deflate'
	-H 'Accept-Language: en-US,en;q=0.8,pt;q=0.6,es;q=0.4'
	-H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/54.0.2840.98 Safari/537.36'
	-H 'Content-Type: application/x-www-form-urlencoded; charset=UTF-8'
	-H 'Accept: */*'
	-H 'Cache-Control: max-age=0'
	-H 'X-Requested-With: XMLHttpRequest'
	-H 'Connection: keep-alive'
	-H "Referer: http://$host:$teamcity_port/mnt"
	-H 'DNT: 1'
	--data 'dbType=HSQLDB2&connHost=&connInst=&connDB=&connIntegratedSecurity=-&connUser=&connPwd='
	--compressed
	-b $teamcity_cookies_file || die "Unable to set the Data Directory of TeamCity"

success "Successfully set the Data Directory of TeamCity."

#Second configuration page...

curl "http://$host:$teamcity_port/mnt"
	-H 'DNT: 1'
	-H 'Accept-Encoding: gzip, deflate, sdch'
	-H 'Accept-Language: en-US,en;q=0.8,pt;q=0.6,es;q=0.4'
	-H 'Upgrade-Insecure-Requests: 1'
	-H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/54.0.2840.98 Safari/537.36'
	-H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8'
	-H "Referer: http://$host:$teamcity_port/mnt"
	-H 'Connection: keep-alive'
	-H 'Cache-Control: max-age=0'
	--compressed
	-b $teamcity_cookies_file || die "Unable to set the Database Type of TeamCity"

success "Successfully set the Database Type of TeamCity."


#Third configuration page...

curl "http://$host:$teamcity_port/showAgreement.html"
		-H "Origin: http://$host:$teamcity_port"
		-H 'Accept-Encoding: gzip, deflate'
		-H 'Accept-Language: en-US,en;q=0.8,pt;q=0.6,es;q=0.4'
		-H 'Upgrade-Insecure-Requests: 1'
		-H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/54.0.2840.98 Safari/537.36'
		-H 'Content-Type: application/x-www-form-urlencoded'
		-H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8'
		-H 'Cache-Control: max-age=0'
		-H "Referer: http://$host:$teamcity_port/showAgreement.html"
		-H 'Connection: keep-alive'
		-H 'DNT: 1'
		--data 'accept=true&_accept=&_sendUsageStatistics=&Continue=Continue+%C2%BB'
		--compressed
		-b $teamcity_cookies_file || die "Unable to accept the TeamCity license agreement programmatically."

success "Successfully accepted the TeamCity license agreement programmatically."

#Admin configuration page

# curl 'http://192.168.56.249:3001/createAdminSubmit.html'
# 	-H 'Origin: http://192.168.56.249:3001'
# 	-H 'Accept-Encoding: gzip, deflate'
# 	-H 'Accept-Language: en-US,en;q=0.8,pt;q=0.6,es;q=0.4'
# 	-H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/54.0.2840.98 Safari/537.36'
# 	-H 'Content-type: application/x-www-form-urlencoded; charset=UTF-8'
# 	-H 'Accept: text/javascript, text/html, application/xml, text/xml, */*'
# 	-H 'X-Prototype-Version: 1.7.3'
# 	-H 'X-Requested-With: XMLHttpRequest'
# 	-H 'Connection: keep-alive'
# 	-H 'Referer: http://192.168.56.249:3001/setupAdmin.html'
# 	-H 'DNT: 1'
# 	--data 'username1=jrocha&submitCreateUser=&publicKey=009bef1d51157d303e6f84133f289eb19b4b0c6a25fecda0f07d94c5d17d1e91c4930eb9503ae1dfe6ad314bd121ab3df721652a3c2f32ed8368418c5bad66cc5d6f28bcc8b0b04bcece4a8adfb10341b3fa4c2be3a3b25d8448e878aacc79b71e914ca35344d958555e4d45411ae1fa5477c28ff2f585d087b00d5b342123d51d&encryptedPassword1=47646bcffae04fe6ca44249316805daa30e65294e8e6c8d8a6c9fd6222828175f335b0c1f4105c489c80fdcb9437af01d6ece0b12e252364f3455e6a3eb307b80f8a100a4ad18a09a1ecbfcf665f3507687faa07b8bce291684b3e9a5efde835e8f153d09320916e4a6a0dbe04671930a5ce33df7bc4a3c3224651fdc1d4326c&encryptedRetypedPassword=0490792eb077899a75f785e8ca4a6e7259202363d0a7a88d980e5ff88258d7e6ea521577d7a852746c6dbdc445f146c56b9e0964b7640ed47f986439b06d61b6cc5d66a3af7830bc60c28bcabc2360e784139102e89c3e38c0173715497c64470b439e33f5c5cf090f98ba61034bbaff6188e1c8cdbe44de5dd5439307058cc2' --compressed

#go back to initial dir
cd $setup_dir || die "Unable to return to starting directory during TeamCity Setup."
