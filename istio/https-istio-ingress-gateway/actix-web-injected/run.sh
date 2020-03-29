
# inject proxy
istioctl kube-inject -f actix-web-injected-deployment.yaml | kubectl apply -f -
kubectl apply -f actix-web-injected-service.yaml
kubectl apply -f actix-web-injected-gateway.yaml
