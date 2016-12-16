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

puts "Configuring Vagrant VM #{ENV['VAGRANT_VM_NAME']} on IP #{ENV['VAGRANT_VM_IP']}."

Vagrant.configure("2") do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://atlas.hashicorp.com/search.
  config.vm.box = "ubuntu/xenial64"
  config.vm.box_version = "20161214.0.1"

  if ENV['VAGRANT_VM_SSH_USERNAME'] != nil && ENV['VAGRANT_VM_SSH_PASSWORD'] != nil
    config.ssh.shell = "bash -c 'BASH_ENV=/etc/profile exec bash'"

    config.ssh.username=ENV['VAGRANT_VM_SSH_USERNAME']
    puts "SSH username to connect to the VM will be " + config.ssh.username

    config.ssh.password=ENV['VAGRANT_VM_SSH_PASSWORD']
    puts "SSH password to connect to the VM will be " + config.ssh.password

    config.ssh.insert_key = true
  end

  puts "IP of Virtualbox: #{ENV['VAGRANT_VM_IP']}"

  config.vm.define "#{ENV['VAGRANT_VM_NAME']}" do |subconfig|
    subconfig.vm.network :private_network, ip: "#{ENV['VAGRANT_VM_IP']}"
    subconfig.vm.network :forwarded_port, :guest => 22, :host => 7665
    subconfig.vm.hostname = "#{ENV['VAGRANT_VM_NAME']}"
    config.vm.boot_timeout= 600
  end

  config.vm.provider "virtualbox" do |vb|
     # Display the VirtualBox GUI when booting the machine
     # vb.gui = true
     # Customize the amount of memory on the VM:
     vb.memory = "1024"
     vb.cpus = "2"
     vb.name = "#{ENV['VAGRANT_VM_NAME']}"

     vb.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
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
