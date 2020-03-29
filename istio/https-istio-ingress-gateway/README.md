# 创建证书

    openssl req -x509 -nodes -newkey rsa:2048 -keyout privkey.pem -out cert.pem -subj "/CN=*.example.com"

# 证书添加到 kubernetes secret

    kubectl create -n istio-system secret tls istio-ingressgateway-certs --key privkey.pem --cert cert.pem

查看证书和私钥是否部署成功

    kubectl exec -it -n istio-system \
      $(kubectl -n istio-system get pods \
        -l istio=ingressgateway \
        -o jsonpath='{.items[0].metadata.name}') \
      -- ls -l /etc/istio/ingressgateway-certs/

# 部署 deployment, service, gateway, virtualservice

    istioctl kube-inject -f actix-web-injected-deployment.yaml | kubectl apply -f -
    kubectl apply -f actix-web-injected-service.yaml
    kubectl apply -f actix-web-injected-gateway.yaml

# 测试

首先拿到 ingress gateway 的 ELB 地址

    INGRESS_HOST=$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.status.loadBalancer.ingress[0].hostname}')

通过 ping 记录 ELB 的 ip: <INGRESS HOST IP>

    ping $INGRESS_HOST

用 `curl --resolve` 来测试，注意替换 <INGRESS HOST IP>

    curl -k --resolve "actix-web-injected-https.istio.mycompany.example.com:443:<INGRESS HOST IP>" https://actix-web-injected-https.istio.mycompany.example.com:443/ping

输出

    {"message":"pong"}
