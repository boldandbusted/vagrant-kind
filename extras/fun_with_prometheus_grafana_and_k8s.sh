helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update
helm install my-metrics-server bitnami/metrics-server --version 5.3.5
helm install my-kube-state-metrics bitnami/kube-state-metrics --version 1.1.6
helm repo update
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
helm install my-prometheus-stack prometheus-community/kube-prometheus-stack -n monitor
sleep 60
kubectl port-forward -n monitor prometheus-my-prometheus-stack-kube-p-prometheus-0  9090 --address 0.0.0.0 &
echo "Prometheus UI: https://kind.test:9090/"
kubectl --namespace monitor port-forward svc/my-prometheus-stack-grafana 3000:80 --address 0.0.0.0 &
echo "Grafana: https://kind.test:3000/ user: admin password: prom-operator"


