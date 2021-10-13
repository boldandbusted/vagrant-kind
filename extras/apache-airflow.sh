#!/usr/bin/env bash

. ./lib/dashboard.sh

helm repo add bitnami https://charts.bitnami.com/bitnami
helm install my-release bitnami/airflow

exit

sleep 60
kubectl port-forward service/my-release-airflow 8443:8080 --address=0.0.0.0 >> /dev/null &
echo "Browse to https://kind.test:8443/ for Apache Airflow interface."
export AIRFLOW_PASSWORD=$(kubectl get secret --namespace default my-release-airflow -o jsonpath="{.data.airflow-password}" | base64 --decode)
echo Password: $AIRFLOW_PASSWORD 
