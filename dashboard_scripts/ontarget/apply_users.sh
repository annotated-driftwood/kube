cd `dirname $(readlink -f "$0")`
kubectl apply -f dashboard-admin.yaml  
kubectl apply -f dashboard-read-only.yaml
