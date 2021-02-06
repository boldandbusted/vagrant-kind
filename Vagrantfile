# -*- mode: ruby -*-
# vi: set ft=ruby :

hostname = 'kind'
tld = 'test'

Vagrant.configure(2) do |config|
  if Vagrant::Plugin::Manager.instance.plugin_installed?('vagrant-dns')
    config.dns.tld = tld
  end

  ["20.04"].each do |dist|
    config.vm.define "#{hostname}" do |node|
      node.vm.hostname = hostname
      node.vm.network "private_network", ip: '192.168.34.10'

      node.vm.provider :hyperv do |hv|
        node.vm.box = 'bento/ubuntu-20.04'
        hv.memory = '8192'
        hv.cpus = '2'
        hv.vmname = hostname
        hv.vm_integration_services = {
          guest_service_interface: true,
          time_synchronization: true
        }
      end

      node.vm.provider :virtualbox do |vb|
        node.vm.box = "bento/ubuntu-#{dist}"
        if Vagrant::Plugin::Manager.instance.plugin_installed?('vagrant-dns')
          vb.customize [
            'modifyvm', :id,
            '--natdnshostresolver1', 'on'
            # some systems also need this:
            # '--natdnshostresolver2', 'on'
          ]
        end
        # vb.gui = true
        vb.memory = '8192'
        vb.cpus = '2'
      end

      # SSH forwarding so that we can access Github as our selves
      node.ssh.forward_agent = true
      node.vm.synced_folder ".", "/vagrant", type: "rsync"
      node.disksize.size = "50GB"

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

      node.vm.provision 'ansible_local' do |ansible|
        ansible.install = false
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
