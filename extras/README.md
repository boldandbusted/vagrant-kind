# Extras

Files in this directory could be used to create example deployments, demos, local proof-of-concepts,etc. All are meant to be run within the Vagrant VM/Guest.

Quality may vary, though there should be simple instructions output at the end of the script runs. Please report any issues, and include the shell output in the Issue you report. New 'extras' are also welcome! Thanks!

## Examples

### Kubernetes Dashboard

To run and access the Kubernetes Dashboard:

```shell
vagrant up
vagrant ssh

# Inside the guest

cd /vagrant/extras/
. ./k8s-dashboard.sh
```

### Apache Airflow

To run and access Apache Airflow:

```
vagrant up
vagrant ssh

# Inside the guest

cd /vagrant/extras/
. ./apache-airflow.sh
```

### Prometheus and Grafana stack

```shell
vagrant up
vagrant ssh

# Inside the guest

cd /vagrant/extras/
. ./fun_with_prometheus_grafana_and_k8s.sh
```

## TODO
* Add `docker run -it --net=host -e SERVER_PORT=7070 hjacobs/kube-ops-view`
