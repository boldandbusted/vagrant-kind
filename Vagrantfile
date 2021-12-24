# -*- mode: ruby -*-
# vi: set ft=ruby :

hostname = 'kind'
tld = 'test'
vm_ram = '8192'
vm_cpus = '2'
vm_disksize = '200GB'
vm_host_ip = '192.168.61.10'

Vagrant.configure(2) do |config|
  if Vagrant::Plugin::Manager.instance.plugin_installed?('vagrant-dns')
    config.dns.tld = tld
  end

  ["21.04"].each do |dist|
    config.vm.define "#{hostname}" do |node|
      node.vm.hostname = hostname
      node.vm.network "private_network", ip: vm_host_ip

      node.vm.provider :hyperv do |hv|
        node.vm.box = "bento/ubuntu-#{dist}"
        hv.memory = vm_ram
        hv.cpus = vm_cpus
        hv.vmname = hostname
        hv.vm_integration_services = {
          guest_service_interface: true,
          time_synchronization: true
        }
      end

      node.vm.provider :virtualbox do |vb|
        #node.vm.box = "bento/ubuntu-#{dist}"
        node.vm.box = "ubuntu/hirsute64"
        if Vagrant::Plugin::Manager.instance.plugin_installed?('vagrant-dns')
          vb.customize [
            'modifyvm', :id,
            '--natdnshostresolver1', 'on'
            # some systems also need this:
            # '--natdnshostresolver2', 'on'
          ]
        end
        # vb.gui = true
        vb.memory = vm_ram
        vb.cpus = vm_cpus
      end

      # SSH forwarding so that we can access Github as ourselves
      node.ssh.forward_agent = true
      node.vm.synced_folder ".", "/vagrant", type: "rsync"
      node.disksize.size = vm_disksize

      node.vm.provision 'shell' do |shell|
        content = %(
        apt-get update
        apt-get dist-upgrade -y
        apt-get install bash-completion python-is-python3 python-dev-is-python3 python3-pip -y
        update-alternatives --install /usr/bin/pip pip /usr/bin/pip3 1
        pip install ansible
        )
        shell.inline = content
        shell.reboot = true
      end

      node.vm.provision 'shell' do |shell|
        content = %(
        echo 'set -g default-terminal "tmux-256color"' >> ~/.tmux.conf
        )
        shell.inline = content
        shell.privileged = false
      end

      node.vm.provision 'ansible_local' do |ansible|
        ansible.install = false
        ansible.compatibility_mode = "2.0"
        ansible.playbook = 'vagrant_role.yml'
        #ansible.install_mode = "pip"
        #ansible.verbose = "vvvv"
        ansible.extra_vars = {
          admin_user: 'ubuntu'
        }
      end
    end
  end
end
