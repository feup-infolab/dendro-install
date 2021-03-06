[![Codacy Badge](https://api.codacy.com/project/badge/Grade/75e227c63f6e47b494763d5c81366ad4)](https://www.codacy.com/app/silvae86/dendro-install?utm_source=github.com&amp;utm_medium=referral&amp;utm_content=feup-infolab/dendro-install&amp;utm_campaign=Badge_Grade)
[![Chat on gitter](https://img.shields.io/gitter/room/badges/shields.svg)](https://gitter.im/feup-infolab/dendro-install)

### Looking for a Docker Image to try out Dendro quickly in your computer? 

1. Install [Docker](https://docs.docker.com/docker-for-windows/install/)
2. Open a Terminal window on Linux/Mac or press Ctrl+R on Windows, type cmd.exe in the box that appears and press Enter
3. Clone the Dendro Docker installation repository by pasting this code
````bash
git clone https://github.com/feup-infolab/dendro-install-docker dendro-install-docker
````
4. Run the installation command in the same terminal and wait until no more text is printed. It can take several minutes.
````bash
cd dendro-install-docker
docker-compose up
````
5. Access your dendro installation at [127.0.0.1:3001](http://127.0.0.1:3001) in your browser.
6. When you want to stop Dendro, just press Ctrl+C at the terminal window

We provide a [Docker image](https://hub.docker.com/r/joaorosilva/dendro/) for getting you up and running quickly. For deployment in a production server, however, we recommend you use the Dendro install scripts.

# What is Dendro?

The Dendro platform is a completely open-source platform designed to help researchers describe their datasets, fully built on Linked Open Data. It is designed to capture data and metadata during the research workflow. Whenever researchers want to publish a dataset, they can export to repositories such as [CKAN](http://ckan.org/), [DSpace](http://www.dspace.org/), [Invenio](http://invenio-software.org/), or [EUDAT's B2Share](https://www.eudat.eu/services/b2share). Any repository can be added by writing small plug-ins.

It is under development at [Faculdade de Engenharia da Universidade do Porto](https://www.fe.up.pt/)'s [Infolab](http://infolab.fe.up.pt) since 2013. If you are interested in the academic foundations and innovations behind Dendro, please check out our **publications** at the [Dendro official website](http://dendro.fe.up.pt).


You are free to use Dendro to build any service for your research group or institution.

# Demo instance

**See the [DEMO PAGE](http://dendro.fe.up.pt/demo).** If it is down, please file an [issue](https://github.com/feup-infolab-rdm/dendro/issues/new).

# What is this package?

This package allows you to

 * Install and try out [Dendro](http://dendro.fe.up.pt/blog/index.php/dendro/) without having to write any code
 * We use a [virtual machine](https://en.wikipedia.org/wiki/Virtual_machine) inside your computer and not your real computer.
   * No garbage is installed on it
   * When you are done, just delete the virtual machine, and nothing will remain.

## Requirements

* All OS's
	* **2GB of free memory for the Virtual Machine**

* Mac OS X
	* 10.6.x+

* Linux (Any Debian-derived distro)
	* Ubuntu and Linux Mint
	* Tested on Debian Jessie

* Windows 7+
	* Install ImageMagick [executable](https://www.imagemagick.org/script/download.php)
	* During the ImageMagick instalation check the option "Install legacy utilities (e.g. convert)". This is needed for generating resources thumbnails in Dendro.

## Dependencies

Dendro relies on

 * OpenLink Virtuoso for the database layer
 * ElasticSearch for free text searching
 * MongoDB and its GridFS system for scalable file storage
 * NodeJS and ExpressJS for the server side
 * Twitter Boostrap

#	Installation Tutorials on YouTube

| Users            | Developers                                                                              |
|--------------------|------------------------------------------------------------------------------------------|
| Want to try Dendro? Watch the video below. It is intended to get you up and running with a fully configured Virtual Machine that you can destroy after you are done. | Interested in developing for the Dendro platform? You should follow the video for Regular Users before setting up the VM for development. |
| [![YouTube installation tutorial for Dendro](http://i.imgur.com/3r1lfot.png)](https://www.youtube.com/watch?v=YEKQ1InfmOE) | Run `./conf/scripts/install.sh -d` on the `dendro-install/` after following the normal tutorial. |

# Step by step instructions



## For users

1. **Download and install the _latest versions_ of:**
	*	[OracleVirtualBox](https://www.virtualbox.org/)
	*	[Vagrant](https://www.vagrantup.com/downloads.html)

	*	**DO NOT** use packaged versions from your Linux Distro, as they are often outdated and will not work. On Debian-based distros you can use `$ sudo gdebi <package.deb>` to install `.deb` packages.
	* 	[Git](https://git-scm.com/downloads)

2. **Check that everything is working**
	* On Windows, press Windows+R, type `powershell.exe`, press Enter
		* Paste: `vagrant -v; VBoxControl.exe -v; git --version`
	* On the Mac or in Linux, open your Terminal application
		* Paste: `vagrant -v; VBoxManage -v -v; git --version`
		* You should see the versions of the installed programs.

3. **Installing with default settings**
	* Cloning (Mac + Linux)

		Open Terminal and paste the following:

		```bash
		git clone https://github.com/feup-infolab-rdm/dendro-install.git;
		cd dendro-install;
		chmod +x ./install.sh;
		./install.sh
    ./install.sh -r
		```
      *
      ```bash
      ./install.sh -d #for developing only! This will open all ports of all the servers DO NOT USE IN PRODUCTION ENVIRONMENTS!!
      ```

	* Cloning using Powershell (Windows)

		Press Windows+R, type `powershell.exe`, press Enter and paste the following:

		```powershell
		git config --global core.autocrlf false
		git clone https://github.com/feup-infolab-rdm/dendro-install.git
		git config --global core.autocrlf true
		cd dendro-install\windows
		.\install.bat
		```

4. (optional) **Customize the installation**
	* Edit the `constants.sh` file if you want to customize the installation
	* You may want to change the following parameters:
		* Root passwords for all services (MySQL, ElasticSearch, Virtuoso...) are specified in `constants.sh`
		* `svn_user` + `svn_user_password` --> Until we have a public GitHub repository, these are the credentials for accessing the private Subversion repository at FEUP
		* `emailing_account_gmail_user` + `emailing_account_gmail_password`  
			* Credentials of a GMail account for sending emails such as password resets
		* You will find what needs to be changed by searching for the `FIXME_____` keyword within `constants.sh`

5. **Access your new Dendro installation**
	* The default credentials for the administrator are:
		`user: admin`
		`password: admintest123`
		
## Using Dendro with Shibboleth for authentication
1. **Dendro-Install by default does not install Shibboleth. To install Shibboleth edit the file /scripts/constants.sh:**
	* Change the value for "shibboleth_authentication_enabled" to "true"

2. **Dendro needs public and private keys to communicate with the Shibboleth Identity Provider(IDP). You can specify the 		path for them by editing the file /scripts/secrets.sh.**
	* Edit the following parameters accordingly:
	
	* shibboleth_business_logic_handler="bootup/models/shibboleth/shibboleth_UP.js" 
	#this is the file that will handle all of the logic with the service provider(login, callback, fails, etc) in this case for the University of Porto
	
	
	* shibboleth_authentication_callback_url="shibboleth_authentication_callback_url"
	#this is the endpoint where the login request falls back into after the authentication in the IDP is successful. Example value: "http://dendropessoal.up.pt:3001/Shibboleth/login/callback"
	
	* shibboleth_authentication_entry_point="shibboleth_authentication_entry_point"
	#this is the IDP entry point for the Shibboleth authentication, in this case for the University of Porto. Example value: "https://stark.up.pt/idp/profile/SAML2/Redirect/SSO"
	
	* shibboleth_authentication_issuer="shibboleth_authentication_issuer"
	#this url identifies the issuer (the service provider, usually ends with "shibboleth"). Example value: "https://dendropessoal.up.pt/shibboleth"
	
	* shibboleth_authentication_session_secret="shibboleth_authentication_session_secret"
	#the session secret
	
	* shibboleth_authentication_button_text="Sign-in with shibboleth UP"
	#A label for the authentication button
	
	* shibboleth_authentication_idp_cert_path="shibboleth_authentication_idp_cert_path"
	#The IDP public key file path in your machine, the IDP must provide this to you. It Must be uploaded to the machine before the installation or Dendro-Install will warn you and exit. Example value: "/Users/nelsonpereira/Desktop/dendro/conf/cert/idp_cert.pem"
	
	* shibboleth_authentication_key_path="shibboleth_authentication_key_path"
	#The Service provider(Dendro) private key path, if the file does not exist Dendro-Install will generate it and warn you to provide an updated metadata.xml file to the IDP. Example value: "/Users/nelsonpereira/Desktop/dendro/conf/cert/key.pem"
	
	* shibboleth_authentication_cert_path="shibboleth_authentication_cert_path"
	#The Service provider(Dendro) public key path, if the file does not exist Dendro-Install will generate it and warn you to provide an updated metadata.xml file to the IDP. Example value: "/Users/nelsonpereira/Desktop/dendro/conf/cert/cert.pem"
	
	* shibboleth_authentication_button_url="shibboleth_authentication_button_url"
	#The URL for the authentication button. Example value: "http://dendropessoal.up.pt:3001/Shibboleth"


* After the previous step is done, the Dendro installation will continue as usual.

## For developers

Developers need to make some changes to the virtual machine that is generated by the Vagrant scripts above to set up their development environment.

### Script arguments

 - `-d` : **Set up the VM for development**. Needed to make the VM open all ports of its servers to the outside world. or a server. This will allow you to work on your host machine, use the editor and debugger you want to develop for Dendro, while having all the dependencies neatly running on your VM. When you need to reset everything, simply delete the VM and start over. DO NOT RUN ON A PRODUCTION MACHINE.
 - `-r` : **Refresh the existing installation**. Only code and ontologies will be reloaded, but no dependencies will be installed. Useful when testing to not instal Virtuoso from source every time as it takes long).
 - `-c` : **Install TeamCity**. Installs TeamCity 10.0.4 into the VM or a server.
 - `-a` : **Install TeamCity Build Angent**. Needed to make the TeamCity Server run build jobs on the server. TeamCity will not work without installing a Build Agent.
 - `-t` : **Run Tests**. Updates the code and runs tests on Dendro.
 - `-j` : **Install Jenkins**. Install the Jenkins platform.
 - `-b < branch_name >` : **Install a branch of Dendro**. Installs Dendro with the branch < branch_name > into the VM or server.

These flags are valid for both Windows and Linux/Mac installations

#### For the curious
If you want to know what the `./install.sh -d` command does, see the video below. Because following this video took too much of an effort every time we wanted to setup a machine for development, we have decided to automate those steps in the installation script with the `-d` flag.

[![YouTube Development setup tutorial for Dendro](http://i.imgur.com/Z7I9B98.png)](https://www.youtube.com/watch?v=baEsv-KTK8w).

### IMPORTANT! Setting up a VM for tests

Since we do not want to destroy our graphs in the development VM every time we run the tests, we have created a separate test setting in the deployment_configs.js file. This connects to a different VM, with IP 192.168.56.24**8** instead of 192.168.56.249.

This means that to run your tests continuously, you have a second VM running, with that IP.

To do that, you must:

- clone this repository again to another folder
- edit the `scripts/constants.sh` file, changing the IP to 192.168.56.24**8** and the config name to something different. Example:

#### Before

```bash
#!/usr/bin/env bash

#global
active_deployment_setting='dendroVagrantDemo'
#will be used to generate URLs relative to a base address, so set it wisely
	host="192.168.56.249"
```
#### After

```bash
#!/usr/bin/env bash

#global
active_deployment_setting='dendroVagrantDemoTESTS'
#will be used to generate URLs relative to a base address, so set it wisely
	host="192.168.56.248"
```

### Install Java 1.8 (required for JDBC Database Adapter). This is mandatory

#### For Debian Linux

```bash
sudo apt-get install oracle-java8
```

#### For Ubuntu Linux

```bash
#install Java 8
sudo apt-get install -y python-software-properties debconf-utils
sudo add-apt-repository -y ppa:webupd8team/java
sudo apt-get update
echo "oracle-java8-installer shared/accepted-oracle-license-v1-1 select true" | sudo debconf-set-selections
sudo apt-get install -y oracle-java8-installer
```

```bash
sudo update-alternatives --config java
#Select the Oracle JDK
```

Before:

```bash
➜  dendro-install git:(adding-unique-identifiers) ✗ java -version
Picked up _JAVA_OPTIONS:   -Dawt.useSystemAAFontSettings=gasp
openjdk version "1.8.0_141"
OpenJDK Runtime Environment (build 1.8.0_141-8u141-b15-3-b15)
OpenJDK 64-Bit Server VM (build 25.141-b15, mixed mode)
```

After:

```bash
➜  ~ java -version
Picked up _JAVA_OPTIONS:   -Dawt.useSystemAAFontSettings=gasp
java version "1.8.0_144"
Java(TM) SE Runtime Environment (build 1.8.0_144-b01)
Java HotSpot(TM) 64-Bit Server VM (build 25.144-b01, mixed mode)
```

### Cloning the dendro repository, initial setup and starting up the app

#### For Mac / Linux

```bash

#install NVM, Node 8.9.0 + Node Automatic Version switcher
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.1/install.sh | bash &&
export NVM_DIR="$HOME/.nvm" &&
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

nvm install 8.9.0

#clone repo
git clone https://github.com/feup-infolab/dendro.git
cd dendro

#install prerequisites
sudo apt-get -y -f -qq install unzip devscripts autoconf automake libtool flex bison gperf gawk m4 make libssl-dev git imagemagick subversion zip htop redis-server htop build-essential --fix-missing

#install everything
./conf/scripts/install.sh

#start app
node src/app.js
```

#### For Windows

##### Install NVM

Follow the installer [HERE](https://github.com/coreybutler/nvm-windows/releases).

##### Installing NodeJS and Automatic Version Manager

```bash
nvm install 8.9.0
```

##### Installing Dendro

```bash
#clone repo
git clone https://github.com/feup-infolab/dendro.git
cd dendro

#on Windows you may need to do this to avoid git certificate errors (do this only if you get errors, as this is just a workaround and will skip certificate validations)
git config --global http.sslverify "false"

#activate node 8.9.0
nvm use 8.9.0

#install dependencies. Will also run bower install whenever needed
npm install

grunt #use grunt to put everything in place

#start app
npm start
```

### NPM Commands available at the project root

```bash
npm run everything #runs installation, grunt, tests, report results and code coverage
npm run calculate-coverage #updates test coverage report
npm run report-coverage #report coverage to codecov
npm run watch-dev #start nyc watcher (runs tests on save on every file in the project)
npm run test #run tests
npm run profile #runs tests with --prof flag to profile dendor performance
npm run remote-debug #start the app in debug mode for remote debugging
npm run fix-server #run eslint to fix the code style on src/
npm run fix-client ##run eslint to fix the code style on public/app/
npm run fix-tests ##run eslint to fix the code style on test/
npm run fix #run eslint to fix the code style on src/, public/app/ and test/ directories
```

#### USE THIS ONLY if you have permissions issues installing bower or your bower_components folder becomes read-only by some reason

```bash
sudo chown -R [[user]] ~/.npm ~/.cache ~/.config #REPLACE [[user]] with your username.
```

### Configuring Webstorm

If you want to run tests, run the program or generate test coverage reports, these are the configuration screens on a Mac (slight changes will be needed for the Windows counterparts, such as changing the location of the `node` executable). There are three tasks:

![configs](https://github.com/feup-infolab/dendro-install/blob/master/images/edit_configs.png?raw=true)

**Mocha (run tests with live results in the IDE**

![mocha](https://github.com/feup-infolab/dendro-install/blob/master/images/mocha.png?raw=true)

**Node (Runs the program for manual testing and debugging)**

![node](https://github.com/feup-infolab/dendro-install/blob/master/images/run.png?raw=true)

**NPM Test task (runs tests, generates coverage reports)**

![npm](https://github.com/feup-infolab/dendro-install/blob/master/images/npm-codecoverage.png?raw=true)

**ESLint Configuration**

You should configure ESLint in WebStorm as follows. This allows you to get warnings about best practices on code style, which helps you write clean code.

![eslint](https://github.com/feup-infolab/dendro-install/blob/master/images/eslint.png?raw=true)

### Configuring Visual Studio 2017 for running tests

Create a new run configuration and customize it as in the following screens. This is useful for debugging mocha tests in WebStorm when the breakpoints are not being hit (we believe this is a bug with WebStorm).

![npm](https://github.com/feup-infolab/dendro-install/blob/master/images/visual_studio_debug_1.png?raw=true)

![npm](https://github.com/feup-infolab/dendro-install/blob/master/images/visual_studio_debug_2.png?raw=true)

#### Watch mode (run tests on any file modification)

Open a terminal and run `npm run watch`. All tests will be run whenever you save a file.
![watch](https://github.com/feup-infolab/dendro-install/blob/master/images/watch.png?raw=true)
![watch2](https://github.com/feup-infolab/dendro-install/blob/master/images/watch2.png?raw=true)

## For sysadmins

If you are maintaining an instance of Dendro installed with these scripts here are some things you should know. In this section, whenever we use the (`[[dendro instance name]]`) wildcard, it means the name you choose for your instance in the `scripts/constants.sh` file of the dendro-install folder. The default value is `dendroVagrantDemo` if you just run these scripts and ssh into the virtual machine using `./ssh_into_vm.sh`.

### Logs locations
There are two log locations:

`/dendro/[[dendro instance name]]` file).
`/var/log/[[dendro instance name]].log`

If you want to check the output of the server live, simply `tail` the log file with `-f`, it will keep monitoring the log file and stream any changes to the console:

`tail -f /var/log/[[dendro instance name]].log` or `tail -f /var/log/[[dendro instance name]].log`

Another way to see the log with more control is to use `journalctl`.

Example of seeing the logs from yesterday in a dendro service:

````bash
sudo journalctl -u dendro_prd_demo_3007_port --since yesterday
````

### Verifying if the dendro service is running / Restarting the service

Dendro runs as a service, which automatically brings back the service if it dies for some reason.

If you need to check if it is running, run:

`sudo service [[dendro instance name] status`

If you need to restart it manually, run:

`sudo service [[dendro instance name] restart`

# Acknowledgements

This work was supported by project NORTE-07-0124-FEDER-000059, financed by the North Portugal Regional Operational Programme (ON.2-O Novo Norte), under the National Strategic Reference Framework (NSRF), through the European Regional Development Fund (ERDF), and by national funds, through the Portuguese funding agency, Fundação para a Ciência e a Tecnologia (FCT). João Rocha da Silva was also supported by research grant SFRH/BD/77092/2011, provided by the Portuguese funding agency, Fundação para a Ciência e a Tecnologia (FCT).

This work is financed by the ERDF – European Regional Development Fund through the Operational Programme for Competitiveness and Internationalisation - COMPETE 2020 Programme and by National Funds through the Portuguese funding agency, FCT - Fundação para a Ciência e a Tecnologia within project POCI-01-0145-FEDER-016736.

<img src="https://github.com/feup-infolab-rdm/dendro-install/raw/master/logos.jpg">

# License

All source code is freely available under a standard [BSD 3-Clause license](https://opensource.org/licenses/BSD-3-Clause).

Copyright (c) 2016, João Rocha da Silva, FEUP InfoLab

All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.

2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

3. Neither the name of the copyright holder nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
