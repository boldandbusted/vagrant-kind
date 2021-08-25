#!/usr/bin/env bash

. ./lib/dashboard.sh

#curl -Lo skaffold https://storage.googleapis.com/skaffold/releases/v1.10.1/skaffold-linux-amd64 && chmod +x skaffold && sudo mv skaffold /usr/local/bin
curl -Lo skaffold https://storage.googleapis.com/skaffold/releases/latest/skaffold-linux-amd64 && chmod +x skaffold && sudo mv skaffold /usr/local/bin
git clone https://github.com/GoogleCloudPlatform/microservices-demo.git
cd microservices-demo
skaffold run
sleep 60
kubectl port-forward deployment/frontend 9292:8080
