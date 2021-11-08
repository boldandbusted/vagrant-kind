#!/usr/bin/env bash

. ./lib/dashboard.sh

git clone https://github.com/GoogleCloudPlatform/microservices-demo.git
cd microservices-demo
kubectl create namespace demo
kubectl -n demo apply -f ./release/kubernetes-manifests.yaml 
kubectl wait --for=condition=available deployment/frontend -n demo
kubectl port-forward deployment/frontend 9292:8080
echo "Browse to http://kind.test:8080"
