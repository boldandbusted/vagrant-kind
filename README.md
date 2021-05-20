# Vagrant-KinD

Keep your main desktop OS clean when playing with Kubernetes, with [Vagrant](https://www.vagrantup.com/) and [KinD](https://kind.sigs.k8s.io/)!

## Prerequisites:
* Vagrant
* VirtualBox > version 6.1
* vagrant-disksize plugin (required)
* `vagrant-dns` plugin (optional, Mac OS X only)

## Quickstart

```shell
git clone --recurse-submodules <THIS REPO URI> vagrant-kind
cd vagrant-kind
vagrant up
vagrant ssh

# Inside vagrant guest
kind create cluster
```

## Tips

### Ansible doesn't do anything

```shell
# If you forget '--recurse-submodules'...
git submodule update --init --remote
```

### Host OS access
To expose K8s ports properly to the Host OS, be sure to add `--address 0.0.0.0` to relevant networking kubectl commands. Example:

```
kubectl port-forward -n kubernetes-dashboard service/dashboard-kubernetes-dashboard 8080:443 --address=0.0.0.0 &
```

### FQDN to reach cluster
`vagrant-dns` plugin users can use the hostname "kind.test" to reach ports exposed. Others will need to use the IP "192.168.34.10".

# Ideas 
Need ideas for what to do with this cluster? Check out KIND's [resources](https://kind.sigs.k8s.io/docs/user/resources/).

Also, browse through the [ArtifactHub](https://artifacthub.io/).

There are some raw experiments available in the [extras](./extras/) subdirectory.

# Thanks!

Thank you to:
* the authors of the Ansible roles I've integrated as git submodules in roles/.
* HashiCorp for making Vagrant
* And thanks to the devs behind [KinD](https://kind.sigs.k8s.io/)!

