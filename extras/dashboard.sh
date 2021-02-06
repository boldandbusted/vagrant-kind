#!/usr/bin/env bash
kind create cluster --config=- <<EOF
# three node (two workers) cluster config

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

kubectl cluster-info --context kind-kind
curl https://baltocdn.com/helm/signing.asc | sudo apt-key add -
sudo apt-get install apt-transport-https --yes
echo "deb https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
sudo apt-get update
sudo apt-get install helm
helm repo add kubernetes-dashboard https://kubernetes.github.io/dashboard/
helm install dashboard kubernetes-dashboard/kubernetes-dashboard -n kubernetes-dashboard --create-namespace
kubectl get all -n kubernetes-dashboard -o wide
# See also:
# https://artifacthub.io/packages/helm/k8s-dashboard/kubernetes-dashboard
# https://github.com/kubernetes-sigs/metrics-server
# https://github.com/kubernetes/dashboard/blob/master/docs/user/access-control/creating-sample-user.md
# https://github.com/kubernetes/dashboard/blob/master/docs/user/accessing-dashboard/README.md
# Note that none of these are the same...
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

kubectl -n kubernetes-dashboard get secret $(kubectl -n kubernetes-dashboard get sa/admin-user -o jsonpath="{.secrets[0].name}") -o go-template="{{.data.token | base64decode}}"
# Grab the output, and use that string as your token for the Dashboard UI

kubectl port-forward -n kubernetes-dashboard service/dashboard-kubernetes-dashboard 8080:443 --address=0.0.0.0 &
