#!/usr/bin/env bash

echo "Create a 7 node, 6 worker cluster"
kind create cluster --config=- <<EOF
# seven node (6 workers) cluster config

kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
- role: control-plane
- role: worker
- role: worker
- role: worker
- role: worker
- role: worker
- role: worker
EOF

echo "KinD cluster info"
kubectl cluster-info --context kind-kind

echo "Prepare for helm use"
curl https://baltocdn.com/helm/signing.asc | sudo apt-key add -
sudo apt-get install apt-transport-https --yes
echo "deb https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
sudo apt-get update
sudo apt-get install helm

echo "Install Kubernetes Dashboard (latest version)"
helm repo add kubernetes-dashboard https://kubernetes.github.io/dashboard/
helm install --atomic dashboard kubernetes-dashboard/kubernetes-dashboard -n kubernetes-dashboard --create-namespace

echo "Show all Kubernetes Dashboard-related resources"
kubectl get all -n kubernetes-dashboard -o wide

echo "Wait until the Dashboard pod is ready"
kubectl wait --for=condition=ready pod -l app.kubernetes.io/name=kubernetes-dashboard -n kubernetes-dashboard

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

echo "Browse to https://kind.test:8080/"
kubectl port-forward -n kubernetes-dashboard service/dashboard-kubernetes-dashboard 8080:443 --address=0.0.0.0 >> /dev/null &

echo "Display the Token (copy and paste this into the Dashboard Web UI)"
kubectl -n kubernetes-dashboard get secret $(kubectl -n kubernetes-dashboard get sa/admin-user -o jsonpath="{.secrets[0].name}") -o go-template="{{.data.token | base64decode}}"
echo
