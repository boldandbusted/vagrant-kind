# Vagrant-KinD

Keep your main desktop OS clean when playing with Kubernetes, with [Vagrant](https://www.vagrantup.com/) and [KinD](https://kind.sigs.k8s.io/)!

## Prerequisites:
* Vagrant
* VirtualBox > version 6.1

## Quickstart

```shell
git clone --recurse-submodules vagrant-kind
cd vagrant-kind
vagrant up
vagrant ssh
kind create cluster
```

Need ideas for what to do with this cluster? Check out KIND's [resources](https://kind.sigs.k8s.io/docs/user/resources/).

Also, browse through the [ArtifactHub](https://artifacthub.io/).

Thank you to the authors of the Ansible roles I've integrated as git submodules in roles/.

Thank you to HashiCorp for making Vagrant, and for creating the 'ansible_local' Vagrant provisioner.

And thanks to the devs behind [KinD](https://kind.sigs.k8s.io/)!


