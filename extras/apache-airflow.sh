#!/usr/bin/env bash

## ERRORS currently on postgresql pod...
## 2021-12-22 01:33:09.756 GMT [613] FATAL: password authentication failed for user "bn_airflow"
## 2021-12-22 01:33:09.756 GMT [613] DETAIL: Password does not match for user "bn_airflow".
## Connection matched pg_hba.conf line 1: "host all all 0.0.0.0/0 md5"
##

. ./lib/dashboard.sh

helm repo add bitnami https://charts.bitnami.com/bitnami
helm install --atomic my-release bitnami/airflow
kubectl port-forward service/my-release-airflow 8443:8080 --address=0.0.0.0 >> /dev/null &
my_ip=$(ip -j -p addr show eth1 | jq -r .[].addr_info[0].local)
echo "Browse to https://kind.test:8443/ or https://$my_ip:8443/ for Apache Airflow interface."
export AIRFLOW_PASSWORD=$(kubectl get secret --namespace default my-release-airflow -o jsonpath="{.data.airflow-password}" | base64 --decode)
echo "Airflow password: $AIRFLOW_PASSWORD"
