. ./lib/dashboard.sh

helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update
helm install --atomic my-metrics-server bitnami/metrics-server --version 5.9.2
helm upgrade --atomic my-metrics-server bitnami/metrics-server --set apiService.create=true
helm install --atomic my-kube-state-metrics bitnami/kube-state-metrics --version 2.1.1
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
helm install --atomic my-prometheus-stack prometheus-community/kube-prometheus-stack --create-namespace -n monitor
sleep 30
kubectl port-forward -n monitor prometheus-my-prometheus-stack-kube-p-prometheus-0 9090 --address 0.0.0.0 >> /dev/null &
echo "Prometheus UI: http://kind.test:9090/"
kubectl --namespace monitor port-forward svc/my-prometheus-stack-grafana 3000:80 --address 0.0.0.0 >> /dev/null &
echo "Grafana: http://kind.test:3000/ user: admin password: prom-operator"


