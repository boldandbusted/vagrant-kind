. ./lib/dashboard.sh

helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
helm install --atomic my-prometheus-stack prometheus-community/kube-prometheus-stack --create-namespace -n monitor \
  --set prometheus.prometheusSpec.podMonitorSelectorNilUsesHelmValues=false \
  --set prometheus.prometheusSpec.serviceMonitorSelectorNilUsesHelmValues=false
sleep 30
kubectl port-forward -n monitor prometheus-my-prometheus-stack-kube-p-prometheus-0 9090 --address 0.0.0.0 >> /dev/null &
#my_ip=$(ip -j -p addr show eth1 | jq -r .[].addr_info[0].local)
echo "Prometheus UI: http://kind.test:9090/ or http://$my_ip:9090/"
kubectl --namespace monitor port-forward svc/my-prometheus-stack-grafana 3000:80 --address 0.0.0.0 >> /dev/null &
echo "Grafana: http://kind.test:3000/ or http://$my_ip:3000/ user: admin password: prom-operator"
