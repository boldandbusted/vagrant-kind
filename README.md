## Prerequisites:
* Vagrant
* VirtualBox > version 6.1

## Quickstart:

```shell
git clone --recurse-submodules <This REPO URI>
cd <repodir>
vagrant up
vagrant ssh
kind create cluster
```

Need ideas for what to do with this cluster? Check out KIND's [resources](https://kind.sigs.k8s.io/docs/user/resources/).

Thank you to the authors of the Ansible roles I've integrated as git submodules in [roles/](./roles).

Thank you to HashiCorp for making Vagrant, and for creating the 'ansible_local' Vagrant provisioner.

And thanks to the devs behind KIND!
