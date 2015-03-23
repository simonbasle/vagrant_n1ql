begin
### Variable declarations - FEEL FREE TO EDIT THESE ###
# Base for IP. %d replaced by node number, eg "192.168.1.10%d" to get 101, 102, ...
#  (be careful of potential ip collisions if public_lan=true !)
ip_base = "192.168.1.11%d"
#allow bridging?
public_lan = false
#if bridged, use dhcp or ip_base?
dhcp = true

# Name of the host endpoint to serve as bridge to local network
#  (if not found vagrant will ask the user for each node)
#default_bridge = "en0: Wi-Fi (AirPort)"

#cluster sizing parameters
default_number_of_nodes = 1
default_RAM_in_MB = 1024
default_number_of_cpus = 1

### END of customization



vagrant_boxes = { # Vagrant Cloud base boxes for each operating system
  "ubuntu10" => {"box_name" => "ubuntu-server-10044-x64-vbox4210",
                 "box_url"  => "http://puppet-vagrant-boxes.puppetlabs.com/ubuntu-server-10044-x64-vbox4210.box"
               },
  "ubuntu12" => "hashicorp/precise64",
  "ubuntu14" => "ubuntu/trusty64",
  "debian7"  => "cargomedia/debian-7-amd64-default",
  "centos5"  => {"box_name" => "centos5u8_x64",
                 "box_url"  => "https://dl.dropbox.com/u/17738575/CentOS-5.8-x86_64.box"
               },
  "centos6"  => {"box_name" => "puppetlabs/centos-6.5-64-puppet",
                 "box_url"  => "puppetlabs/centos-6.5-64-puppet",
                },
  "centos7"  => "hfm4/centos7",
  "windows"  => "emyl/win2008r2",
}

#this is for a N1QL demo, do not change the OS/version
operating_system = 'ubuntu12'
version = '3.5.0'
cburl = 'http://latestbuilds.hq.couchbase.com/couchbase-server/sherlock/1625/couchbase-server-enterprise_4.0.0-1625-ubuntu12.04_amd64.deb'
n1qlurl = 'http://packages.couchbase.com/releases/couchbase-query/dp4/couchbase-query_dev_preview4_x86_64_linux.tar.gz'

### DO NOT EDIT BELOW THIS LINE

# Number of nodes to provision
unless ENV['VAGRANT_NODES'].nil? || ENV['VAGRANT_NODES'] == 0
  num_nodes = ENV['VAGRANT_NODES'].to_i
else
  if num_nodes.nil?
    num_nodes = default_number_of_nodes
  end
end

unless ENV['VAGRANT_CPUS'].nil? || ENV['VAGRANT_CPUS'] == 0
  num_cpus = ENV['VAGRANT_CPUS'].to_i
else
  num_cpus = default_number_of_cpus
end

unless ENV['VAGRANT_RAM'].nil? || ENV['VAGRANT_RAM'] == 0
  ram_in_MB = ENV['VAGRANT_RAM'].to_i
else
  ram_in_MB = default_RAM_in_MB
end

puppet_location ||= "."

# Check to see if the vagrant command given was 'up', if so print a handy dialogue
if ARGV[0] == "up" && !ARGV[1]
  puts "\e[32m=== Upping #{num_nodes} node(s) on #{operating_system} and cb version #{version} ==="
end

### Start the vagrant configuration ###
Vagrant.configure("2") do |config|

  # Disable default Vagrant mount
  config.vm.synced_folder ".", "/vagrant", disabled: true

  # Mount resources and prov
  config.vm.synced_folder "./resources/", "/vagrant/resources", create: true
  config.vm.synced_folder "./prov/", "/vagrant/prov", create: true

  # Define VM properties for each node (for both virtualbox and
  # libvirt providers).
  config.vm.provider :virtualbox do |vb|
    vb.memory = ram_in_MB
    vb.cpus = num_cpus
    vb.customize ["modifyvm", :id, "--ioapic", "on"]
  end
  config.vm.provider :libvirt do |libvirt|
    libvirt.memory = ram_in_MB
    libvirt.cpus = num_cpus
  end

  # Define the vagrant box download location
  if !(vagrant_boxes[operating_system]["box_url"].nil?)
    config.vm.box_url = vagrant_boxes[operating_system]["box_url"]
  end

  # Define the vagrant box name
  if !(vagrant_boxes[operating_system]["box_name"].nil?)
    box_name = vagrant_boxes[operating_system]["box_name"]
  else
    box_name = vagrant_boxes[operating_system]
  end

  # Check to see if the VM is not running Windows and provision with puppet
  if !(operating_system.include?("win"))
    # Provision the server itself with puppet
    config.vm.provision "puppet" do |puppet|
      puppet.manifests_path = puppet_location # Define a custom location and name for the puppet file
      puppet.manifest_file = "puppet.pp"
      puppet.facter = { # Pass variables to puppet
        "version" => version, # Couchbase Server version
        "cburl" => cburl, # Couchbase download location
        "n1qlurl" => n1qlurl #N1QL DP4 download location
      }
    end
  end

  # Provision Config for each of the nodes
  1.upto(num_nodes) do |num|
    config.vm.define "node#{num}" do |node|
      node.vm.box = box_name
      if (public_lan)
          if (dhcp)
              node.vm.network :public_network, :bridge => default_bridge
              puts "Public LAN ip via DHCP, vagrant ssh to the node and get IP via ifconfig"
          else
              node.vm.network :public_network, :bridge => default_bridge, :ip =>  ip_base % num
              puts "Public LAN ip : #{ip_base % num}"
          end
      else
        node.vm.network :private_network, :ip => ip_base % num
        puts "Private network (host only) ip : #{ip_base % num}"
      end
      node.vm.provider "virtualbox" do |v|
        v.name = "N1QL Demo Server Node #{num}"
        if(operating_system.include?("win")) # If the VM is running Windows it will start with a GUI
          v.gui = true
        end
      end
    end
  end

  if ARGV[0] == "up" && !ARGV[1]
      if (public_lan && dhcp)
          puts "\e[32m=== Upping #{num_nodes} node(s) with DHCP enabled ==="
    else
        puts "\e[32m=== Upping #{num_nodes} node(s) on IPs #{ip_base.sub('%d','')}{1..#{num_nodes}} ==="
    end
  end

end
rescue
end
