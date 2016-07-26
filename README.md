#	Dendro automated installation scripts

This package allows you to install the Dendro platform. It is a completely open-source platform designed to help researchers describe their datasets, fully build on Linked Open Data.

It is under development at [Faculdade de Engenharia da Universidade do Porto](https://www.fe.up.pt/)'s [Infolab](http://infolab.fe.up.pt) since 2013.

If you are interested in the academic foundations and innovations behind Dendro, please check out our publications at the [Dendro official website](http://dendro.fe.up.pt).

You are free to use the source code in a commercial product or service. 

##Requirements

* Mac OS X 
	* El Capitan (10.11) or Sierra (10.12)

* Linux (Any Debian-derived distro)
	* Ubuntu and Linux Mint
	* Tested on Debian Jessie 

* Windows 10

##Instructions
1. **Download and install the _latest versions_ of:**
	*	[OracleVirtualBox](https://www.virtualbox.org/)
	*	[Vagrant](https://www.vagrantup.com/downloads.html)

	*	> #####**DO NOT** use packaged versions from your Linux Distro, as they are often outdated and will not work.
	* >On Debian-based distros you can use `$ sudo gdebi <package.deb>` to install `.deb` packages.

2. **Check that everything is working**
	* On Windows, press Windows+R, type `cmd`, press Enter
	* On the Mac or in Linux, open your Terminal application
		* Paste: `vagrant -v; VBoxManage -v`
		* You should see the versions of the installed programs.

3. **Downloading the installer scripts**
	* Cloning: `git clone https://github.com/feup-rdm/dendro-vagrant-install` or
	* Downloading: Click the "Clone or Download" button at the top of this page and then "Download ZIP"

4. **Open the installer scripts folder**
	* `cd dendro-vagrant-install` (if you cloned)
	* Open the folder (if you downloaded)

5. (optional) **Customize the installation**
	* Edit the `constants.sh` file if you want to customize the installation

6. **Run the installation**

	* (Windows) Right-click the install.bat file and select "Run as Administrator"
	* (Mac OS X and Linux) 
		* On the Terminal, type:
			```bash
			cd </scripts/folder/location #open scripts folder directory
			chmod +x ./install.sh
			```



##Dependencies



##Tips


##Acknowledgements




## License

All source code is freely available under a standard [BSD 3-Clause license](https://opensource.org/licenses/BSD-3-Clause).

Copyright (c) 2016, João Rocha da Silva, FEUP Infolab

All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.

2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

3. Neither the name of the copyright holder nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
