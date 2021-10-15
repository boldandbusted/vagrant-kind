#!/usr/bin/env bash

set -e

. ../lib/dashboard.sh

helm repo add hashicorp https://helm.releases.hashicorp.com

kubectl create namespace vault

# Prep for Vault HA Mode and such

# We use Terraform so we can easily generate SSL certs for the CA and such
# See https://github.com/hashicorp/terraform-aws-vault/tree/master/modules/private-tls-cert

curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=$(dpkg --print-architecture)] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt-get update
sudo apt-get instal terraform

repo_root = $(pwd)
echo "Repo root is $repo_root"
cd /dev/shm 
wget https://github.com/hashicorp/terraform-aws-vault/archive/refs/tags/v0.17.0.tar.gz
tar -xvzf v0.17.0.tar.gz
cd terraform-aws-vault-0.17.0/modules/private-tls-cert/
cp $repo_root/custom-tls-variables.tf variables.tf
terraform apply -auto-approve



#helm install vault hashicorp/vault

