#!/usr/bin/env bash

. ./lib/dashboard.sh

# Install Elasticsearch ECK, and add necessary glue to Prometheus
helm repo add elastic https://helm.elastic.co
helm repo update

helm install --atomic elastic-operator elastic/eck-operator -n elastic-system --create-namespace \
  --set podMonitor.enabled=true \
  --set config.metricsPort="8080"
