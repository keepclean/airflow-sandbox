# -*- mode: ruby -*-
# vi: set ft=ruby :

$update_sources = <<-SOURCES
echo "deb http://deb.debian.org/debian/ stable main contrib non-free
deb http://deb.debian.org/debian/ stable-updates main contrib non-free
deb http://deb.debian.org/debian-security stable/updates main
deb http://ftp.debian.org/debian stretch-backports main contrib" | tee /etc/apt/sources.list

apt-get update
SOURCES

Vagrant.configure("2") do |config|
  config.vm.box = "debian/stretch64"
  config.vm.hostname = "airflow"
  config.vm.network "private_network", ip: "10.0.0.254", :adapter => 2

  config.vm.provider "virtualbox" do |vb|
    vb.name = "airflow"
    vb.memory = "2048"
    vb.cpus = "2"
    vb.default_nic_type = "virtio"
  end

  config.vm.provision "shell", inline: $update_sources

  config.vm.synced_folder "salt/", "/srv/salt/", type: "nfs"
  config.vm.provision :salt do |salt|
    salt.masterless = true
    salt.install_master = false
    salt.run_highstate = true
    salt.run_overstate = false
    salt.orchestrations = false
    salt.minion_config = "configs/minion"
    salt.minion_id = "airflow"
    salt.bootstrap_options = "-d -X -x python3"

    salt.python_version = "3"
  end
  config.vm.synced_folder "dags/", "/srv/airflow/dags", type: "nfs"

end
