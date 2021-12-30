#!/usr/bin/env bash

. ./lib/dashboard.sh

# Tried:
# NGINX Ingress: Failed
# Ambassador: Success

kubectl apply -f https://github.com/datawire/ambassador-operator/releases/latest/download/ambassador-operator-crds.yaml

kubectl apply -n ambassador -f https://github.com/datawire/ambassador-operator/releases/latest/download/ambassador-operator-kind.yaml
kubectl wait --timeout=180s -n ambassador --for=condition=deployed ambassadorinstallations/ambassador

echo "NOTE: You will need to annotate any ingress resources you wish to expose via Ambassador"
echo "with the following *after* the resources are created:"
echo
echo "kubectl annotate ingress example-ingress kubernetes.io/ingress.class=ambassador"
