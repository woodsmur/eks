get istio ingress gateway load balancer

	INGRESS_HOST=$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.status.loadBalancer.ingress[0].hostname}')

get ingress host ip(remember ping's output ip: <INGRESS HOST IP>)

	ping $INGRESS_HOST

test using `curl --resolve` 

	curl -k --resolve "actix-web-injected-https.istio.mycompany.example.com:443:<INGRESS HOST IP>" https://actix-web-injected-https.istio.mycompany.example.com:443/ping
