# Extras

Files in this directory could be used to create example deployments, demos, etc. All are meant to be run within the Vagrant VM.

Quality may vary.

## Examples

### Kubernetes Dashboard

To run and access the Kubernetes Dashboard:

```shell
cd extras/
. ./k8s-dashboard.sh
```

### Apache Airflow

To run and access Apache Airflow:

```
cd extras/
. ./apache-airflow.sh
```

## TODO
* Add `docker run -it --net=host -e SERVER_PORT=7070 hjacobs/kube-ops-view`
