#!/usr/bin/env bash

. ./lib/create-cluster.sh

echo "Prep helm"
helm repo add bitnami https://charts.bitnami.com/bitnami
#helm install --atomic my-metrics-server bitnami/metrics-server --version 5.9.2
#helm upgrade --atomic my-metrics-server bitnami/metrics-server --set apiService.create=true
helm repo add metrics-server https://kubernetes-sigs.github.io/metrics-server/
helm repo update

echo "Install metrics-server"
kubectl create namespace monitor
helm install -n monitor --atomic my-metrics-server metrics-server/metrics-server \
  --version 3.6.0 \
  --set apiService.create=true \
  --set args={--kubelet-insecure-tls}

echo "Install kube-state-metrics"
helm install --atomic my-kube-state-metrics bitnami/kube-state-metrics \
  --version 2.1.1

echo "Install Kubernetes Dashboard (latest version)"
helm repo add kubernetes-dashboard https://kubernetes.github.io/dashboard/
helm install -n kubernetes-dashboard --atomic dashboard kubernetes-dashboard/kubernetes-dashboard \
  --create-namespace

echo "Wait until the Dashboard pod is ready"
kubectl wait -n kubernetes-dashboard pod \
  --for=condition=ready \
  -l app.kubernetes.io/name=kubernetes-dashboard 

echo "Prepare token for user login"
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: ServiceAccount
metadata:
  name: admin-user
  namespace: kubernetes-dashboard
EOF

cat <<EOF | kubectl apply -f -
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: admin-user
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cluster-admin
subjects:
- kind: ServiceAccount
  name: admin-user
  namespace: kubernetes-dashboard
EOF

#my_ip=$(ip -j -p addr show eth1 | jq -r .[].addr_info[0].local)
export my_ip="192.168.61.10"

echo "Browse to https://kind.test:8080/ or https://$my_ip:8080/"
kubectl port-forward -n kubernetes-dashboard service/dashboard-kubernetes-dashboard 8080:443 --address=0.0.0.0 >> /dev/null &

echo "Copy and paste the token below into the Dashboard Web UI"
echo "---snip---"
kubectl get secret -n kubernetes-dashboard \ 
  $(kubectl -n kubernetes-dashboard get sa/admin-user -o jsonpath="{.secrets[0].name}") \
  -o go-template="{{.data.token | base64decode}}"
echo
echo "---snip--"
