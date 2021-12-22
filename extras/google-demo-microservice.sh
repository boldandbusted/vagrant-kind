#!/usr/bin/env bash

. ./lib/dashboard.sh

git clone https://github.com/GoogleCloudPlatform/microservices-demo.git
cd microservices-demo
kubectl create namespace demo
kubectl -n demo apply -f ./release/kubernetes-manifests.yaml 
kubectl wait --for=condition=available deployment/frontend -n demo
#kubectl port-forward deployment/frontend 9292:8080
kubectl -n demo port-forward svc/frontend 8081:80 --address 0.0.0.0 >> /dev/null &
my_ip=$(ip -j -p addr show eth1 | jq -r .[].addr_info[0].local)
echo "Browse to http://kind.test:8081 or http://$my_ip:8081/"
