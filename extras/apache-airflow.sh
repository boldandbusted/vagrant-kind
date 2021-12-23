#!/usr/bin/env bash

echo "This chart doesn't work at the moment. See https://github.com/boldandbusted/vagrant-kind/issues/8 ."
exit 1

. ./lib/dashboard.sh

helm repo add apache-airflow https://airflow.apache.org/
helm install my-airflow apache-airflow/airflow --version 1.3.0 \
  --set config.core.load_examples=true \
  --set postgresql.postgresqlUsername="postgres" \
  --set postgresql.postgresqlPassword="postgres"
kubectl port-forward service/my-airflow-airflow 8443:8080 --address=0.0.0.0 >> /dev/null &
#my_ip=$(ip -j -p addr show eth1 | jq -r .[].addr_info[0].local)
echo "Browse to https://kind.test:8443/ or https://$my_ip:8443/ for Apache Airflow interface."
export AIRFLOW_PASSWORD=$(kubectl get secret --namespace default my-airflow-airflow -o jsonpath="{.data.airflow-password}" | base64 --decode)
echo "Airflow password: $AIRFLOW_PASSWORD"
