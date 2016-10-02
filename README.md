#	Welcome to Dendro

The Dendro platform is a completely open-source platform designed to help researchers describe their datasets, fully build on Linked Open Data. It is designed to capture data and metadata during the research workflow. Whenever researchers want to publish a dataset, they can export to repositories such as [CKAN](http://ckan.org/), [DSpace](http://www.dspace.org/), [Invenio](http://invenio-software.org/), or [EUDAT's B2Share](https://www.eudat.eu/services/b2share). Any repository can be added by writing small plug-ins.

It is under development at [Faculdade de Engenharia da Universidade do Porto](https://www.fe.up.pt/)'s [Infolab](http://infolab.fe.up.pt) since 2013. If you are interested in the academic foundations and innovations behind Dendro, please check out our **publications** at the [Dendro official website](http://dendro.fe.up.pt).


You are free to use Dendro to build any service for your research group or institution.

##What is this?

This package allows you to 

 * Install and try out [Dendro](http://dendro.fe.up.pt/blog/index.php/dendro/) without having to write any code
 * We use a [virtual machine](https://en.wikipedia.org/wiki/Virtual_machine) inside your computer and not your real computer. 
   * No garbage is installed on it
   * When you are done, just delete the virtual machine, and nothing will remain.

##Requirements

* Mac OS X 
	* 10.6.x+

* Linux (Any Debian-derived distro)
	* Ubuntu and Linux Mint
	* Tested on Debian Jessie 

* Windows 7+
```powershell
	git config --global core.autocrlf false
	git clone https://github.com/feup-infolab-rdm/dendro-install.git
	git config --global core.autocrlf true 
```

##Instructions
1. **Download and install the _latest versions_ of:**
	*	[OracleVirtualBox](https://www.virtualbox.org/)
	*	[Vagrant](https://www.vagrantup.com/downloads.html)

	*	> #####**DO NOT** use packaged versions from your Linux Distro, as they are often outdated and will not work. On Debian-based distros you can use `$ sudo gdebi <package.deb>` to install `.deb` packages.
	* 	[Git](https://git-scm.com/downloads)

2. **Check that everything is working**
	* On Windows, press Windows+R, type `cmd`, press Enter
	* On the Mac or in Linux, open your Terminal application
		* Paste: `vagrant -v; VBoxManage -v; git -v`
		* You should see the versions of the installed programs.

3. **Downloading the installer scripts**
	* Cloning: `git clone https://github.com/feup-rdm/dendro-vagrant-install` or
	* Downloading: Click the "Clone or Download" button at the top of this page and then "Download ZIP"

4. **Open the installer scripts folder**
	* Linux + Mac
		* Open Terminal
		* type `cd dendro-vagrant-install` (if you cloned)
		* Unzip the compressed folder (if you downloaded)
	* Windows 7+
		* Navigate to the folder to where you cloned or downloaded the ZIP (dendro-install, typically)

5. (optional) **Customize the installation**
	* Edit the `constants.sh` file if you want to customize the installation
	* You may want to change the following parameters:
		* Root passwords for all services (MySQL, ElasticSearch, Virtuoso...) are specified in `constants.sh`
		* `svn_user` + `svn_user_password` --> Until we have a public GitHub repository, these are the credentials for accessing the private Subversion repository at FEUP
		* `emailing_account_gmail_user` + `emailing_account_gmail_password`  
			* Credentials of a GMail account for sending emails such as password resets
		* You will find what needs to be changed by searching for the `FIXME_____` keyword within `constants.sh`
		

6. **Run the installation**

	* (Windows)
		* Open the `windows` folder
		* Right-click the `install.bat` file and select "Run as Administrator"
	* (Mac OS X and Linux) 
		* On the Terminal, type:
		* `cd </scripts/folder/location>`
		* `chmod +x ./install.sh`
		* `./install.sh`

7. **Go grab a coffee :-)**
	* Really, the installation takes long, around 30 minutes in an average machine.
	* If the script does not output anything for a while, please don't kill it. We have suppressed all compilation output to save CPU time. Just be patient.
	* Wait until you see this message:
		* `[SUCCESS] Dendro is now installed!`

8. **Access your new Dendro installation**
	* Dendro can be accessed on your browser through the following address: [http://192.168.56.200:3001] 
		* (if you did not change the `constants.sh` file in step **5**).
	* The default credentials for the administrator are:
		`user: admin`
		`password: admintest123`

##Dependencies

Dendro relies on

 * OpenLink Virtuoso for the database layer
 * ElasticSearch for free text searching
 * MongoDB and its GridFS system for scalable file storage
 * NodeJS and ExpressJS for the server side
 * Twitter Boostrap

##Acknowledgements

This work was supported by project NORTE-07-0124-FEDER-000059, financed by the North Portugal Regional Operational Programme (ON.2-O Novo Norte), under the National Strategic Reference Framework (NSRF), through the European Regional Development Fund (ERDF), and by national funds, through the Portuguese funding agency, Fundação para a Ciência e a Tecnologia (FCT). João Rocha da Silva was also supported by research grant SFRH/BD/77092/2011, provided by the Portuguese funding agency, Fundação para a Ciência e a Tecnologia (FCT).

This work is financed by the ERDF – European Regional Development Fund through the Operational Programme for Competitiveness and Internationalisation - COMPETE 2020 Programme and by National Funds through the Portuguese funding agency, FCT - Fundação para a Ciência e a Tecnologia within project POCI-01-0145-FEDER-016736.

<img src="https://github.com/feup-infolab-rdm/dendro-install/raw/master/logos.jpg">

## License

All source code is freely available under a standard [BSD 3-Clause license](https://opensource.org/licenses/BSD-3-Clause).

Copyright (c) 2016, João Rocha da Silva, FEUP InfoLab

All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.

2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

3. Neither the name of the copyright holder nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
