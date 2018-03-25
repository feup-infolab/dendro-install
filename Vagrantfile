# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.

def sanitize_filename(filename)
  # Split the name when finding a period which is preceded by some
  # character, and is followed by some character other than a period,
  # if there is no following period that is followed by something
  # other than a period (yeah, confusing, I know)
  fn = filename.split /(?<=.)\.(?=[^.])(?!.*\.[^.])/m

  # We now have one or two parts (depending on whether we could find
  # a suitable period). For each of these parts, replace any unwanted
  # sequence of characters with an underscore
  fn.map! { |s| s.gsub /[^a-z0-9\-]+/i, '_' }

  # Finally, join the parts with a period and return the result
  return fn.join '.'
end

###INSTALL PLUGINS
#install plugin to keep all the VBox Guest Additions updated.
required_plugins = %w(vagrant-share vagrant-vbguest vagrant-disksize vagrant-proxyconf)

plugins_to_install = required_plugins.select { |plugin| not Vagrant.has_plugin? plugin }
if not plugins_to_install.empty?
  puts "Installing plugins: #{plugins_to_install.join(' ')}"
  if system "vagrant plugin install #{plugins_to_install.join(' ')}"
    exec "vagrant #{ARGV.join(' ')}"
  else
    abort "Installation of one or more plugins has failed. Aborting."
  end
end

###Configuration
puts "Configuring Vagrant VM #{ENV['VAGRANT_VM_NAME']} on IP #{ENV['VAGRANT_VM_IP']}."

if "#{ENV['JENKINS_BUILD']}" == '1'
  puts "[JENKINS] JENKINS build detected."
end

Vagrant.configure("2") do |config|

  if "#{ENV['VAGRANT_USE_SQUID_PROXY_VM']}" == 'true'
    puts "Using Squid proxy VM for quicker deployments..."
    # Enable caching web server
    if Vagrant.has_plugin?("vagrant-proxyconf")
      config.proxy.http     = "http://squid:squid@10.0.0.10:3128/"
      config.proxy.https    = "http://squid:squid@10.0.0.10:3128/"
      config.proxy.no_proxy = "localhost,127.0.0.1,deb.nodesource.com,ppa.launchpad.net,repo.mongodb.org,download.oracle.com,edelivery.oracle.com"
      config.apt_proxy.http     = "http://squid:squid@10.0.0.10:8000/"
      config.apt_proxy.https    = "http://squid:squid@10.0.0.10:8000/"
    end
  end

  #shared folders

  # other config here
  #config.vm.synced_folder "shared_folders/etc/init.d", "/etc/init.d"
  #config.vm.synced_folder "shared_folders/dendro", "/dendro"

  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://atlas.hashicorp.com/search.

  if "#{ENV['JENKINS_BUILD']}" == "1"
    config.vm.boot_timeout= 1200
  else
    config.vm.boot_timeout= 600
  end

  config.vm.box = "ubuntu/xenial64"
  config.vm.box_version = "20170922.0.0"


  #set maximum size of the main hard drive
  config.disksize.size = '100GB'

  puts "IP of Virtualbox: #{ENV['VAGRANT_VM_IP']}"

  config.vm.define "#{ENV['VAGRANT_VM_NAME']}" do |subconfig|
    subconfig.vm.network "private_network", ip: "#{ENV['VAGRANT_VM_IP']}"
    subconfig.vm.hostname = "#{ENV['VAGRANT_VM_NAME']}"
  end

  if ENV['VAGRANT_VM_SSH_USERNAME'] != nil && ENV['VAGRANT_VM_SSH_PASSWORD'] != nil
    config.ssh.username=ENV['VAGRANT_VM_SSH_USERNAME']
    puts "SSH username to connect to the VM will be " + config.ssh.username

    config.ssh.password=ENV['VAGRANT_VM_SSH_PASSWORD']
    puts "SSH password to connect to the VM will be " + config.ssh.password
  end

  config.ssh.shell = "bash -c 'BASH_ENV=/etc/profile exec bash'"
  config.ssh.insert_key = true

  config.vm.provider "virtualbox" do |vb|
     # Display the VirtualBox GUI when booting the machine
     # vb.gui = true
     # Customize the amount of memory on the VM:
     vb.name = "#{ENV['VAGRANT_VM_NAME']}"

     vb.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
     vb.customize [ "modifyvm", :id, "--uart1", "0x3F8", "4" ]
     vb.customize [ "modifyvm", :id, "--uartmode1", "file", File.join(Dir.pwd, "ubuntu-xenial-16.04-cloudimg-console.log") ]

     if "#{ENV['JENKINS_BUILD']}" == "1"
       puts "[JENKINS] Configuring VM for build..."
       #vb.customize ["modifyvm", :id, "--hwvirtex", "off"]
       #vb.customize ["modifyvm", :id, "--cableconnected1", "on"]
       #vb.customize ["modifyvm", :id, "--cableconnected2", "on"]
     else

     end
      vb.cpus = 2
      vb.memory = "4096"
  end

  time = sanitize_filename(Time.new.inspect)
  destination_folder = '/tmp/dendro_setup_scripts/' + time
  destination_folder = destination_folder

  if(ENV['VAGRANT_VM_INSTALL']=="true") then

    puts "Vagrant File starting installation..."
    #send compressed scripts folder
    if File.file?("./scripts.tar.gz") then
      puts "Sending scripts.tar.gz file to #{destination_folder}/scripts.tar.gz...."
      config.vm.provision "file", source: "./scripts.tar.gz", destination: "#{destination_folder}/scripts.tar.gz"
      $unzip_script = <<SCRIPT
        tar -zxf #{destination_folder}/scripts.tar.gz -C #{destination_folder}
SCRIPT
    else
      puts "A scripts.tar.gz file does not exist in the same directory as the Vagrantfile (your installation directory. Aborting Vagrant setup..."
      exit 1
    end

    #run uncompressing script
    config.vm.provision "shell", inline: $unzip_script

    #start install script
    $run_script = <<SCRIPT
    chmod +x #{destination_folder}/scripts/install.sh
    #{destination_folder}/scripts/install.sh #{ENV['VAGRANT_SHELL_ARGS']}
SCRIPT

    config.vm.provision "shell", inline: $run_script
  end
end
