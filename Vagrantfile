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

  puts "IP of Virtualbox: #{ENV['VAGRANT_VM_IP']}"
  
  config.vm.define "#{ENV['VAGRANT_VM_NAME']}" do |subconfig|
    subconfig.vm.network :private_network, ip: "#{ENV['VAGRANT_VM_IP']}"
    subconfig.vm.network :forwarded_port, :guest => 22, :host => 7665
    subconfig.vm.hostname = "#{ENV['VAGRANT_VM_NAME']}"
  end

  config.vm.provider "virtualbox" do |vb|
     # Display the VirtualBox GUI when booting the machine
     # vb.gui = true
     # Customize the amount of memory on the VM:
     vb.memory = "4096"
     vb.cpus = "2"
     vb.name = "#{ENV['VAGRANT_VM_NAME']}"
     
     vb.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
  end
  
  time = sanitize_filename(Time.new.inspect)
  destination_folder = '/tmp/dendro_setup_scripts/' + time
  destination_folder = destination_folder
  
  #send compressed scripts folder
  config.vm.provision "file", source: "./scripts.tar.gz", destination: "#{destination_folder}/scripts.tar.gz"
  
  #uncompress remote gzipped scripts folder
  $unzip_script = <<SCRIPT
    tar -zxf #{destination_folder}/scripts.tar.gz -C #{destination_folder}
SCRIPT
  config.vm.provision "shell", inline: $unzip_script

  $run_script = <<SCRIPT
  chmod +x #{destination_folder}/scripts/install.sh
  #{destination_folder}/scripts/install.sh #{ENV['VAGRANT_SHELL_ARGS']}
SCRIPT
  
  config.vm.provision "shell", inline: $run_script
  
end
