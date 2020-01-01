```bash
helm install --name nginx-ingress stable/nginx-ingress -f values.yaml --namespace nginx-ingress
```

```bash
kubens nginx-ingress
#kubectl get pods -n nginx-ingress
kgpo
```
```
NAME                                             READY   STATUS    RESTARTS   AGE
nginx-ingress-controller-96725                   1/1     Running   0          67m
nginx-ingress-controller-cwv5r                   1/1     Running   0          68m
nginx-ingress-controller-fg92m                   1/1     Running   0          69m
nginx-ingress-default-backend-576b86996d-hb49n   1/1     Running   0          3d12h
```
```bash
#kubectl get services -n nginx-ingress
kgsvc 
```
```
NAME                               TYPE           CLUSTER-IP     EXTERNAL-IP      PORT(S)                      AGE
nginx-ingress-controller           LoadBalancer   10.0.234.248   51.105.101.142   80:30745/TCP,443:31815/TCP   7d19h
nginx-ingress-controller-metrics   ClusterIP      10.0.172.96    <none>           9913/TCP                     146m
nginx-ingress-default-backend      ClusterIP      10.0.194.52    <none>           80/TCP                       7d19h
```
```bash
kubectl create ns sampleapp
kubens sampleapp
kubectl apply -f web-v1-fixed.yaml
kubectl apply -f web-v2-fixed.yaml
kubectl apply -f web-v1-svc.yaml
kubectl apply -f web-v2-svc.yaml
kubectl get pods
```
NAME                      READY   STATUS    RESTARTS   AGE
web-v1-845d5c6978-6sgrl   1/1     Running   0          4h50m
web-v2-fb7cb48f5-kkzkc    1/1     Running   0          4h51m

```

```
```bash
kubectl get service -n sampleapp
```
```
NAME     TYPE       CLUSTER-IP     EXTERNAL-IP   PORT(S)          AGE
web-v1   NodePort   10.0.171.226   <none>        8080:30060/TCP   4h51m
web-v2   NodePort   10.0.156.60    <none>        8080:30225/TCP   4h51m
```
Ingress Definition
```
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: web-ingress
  annotations:
    kubernetes.io/ingress.class: nginx
    nginx.ingress.kubernetes.io/ssl-redirect: "false"
    nginx.ingress.kubernetes.io/rewrite-target: /$2
spec:
  rules:
  - http:
      paths:
      - path: /v2/(.*)
        backend:
          serviceName: web-v2
          servicePort: 8080
      - path: /v1/(.*)
        backend:
          serviceName: web-v1
          servicePort: 8080
```
```bash
kubectl apply -f http-ingress.yaml 
curl -XGET $(kubectl get svc nginx-ingress-controller -n nginx-ingress -o=jsonpath='{.status.loadBalancer.ingress[0].ip}')/v1/

```
```
Hello, world!
Version: 1.0.0
Hostname: web-v1-845d5c6978-xrgpv
```
```bash
curl -XGET $(kubectl get svc nginx-ingress-controller -n nginx-ingress -o=jsonpath='{.status.loadBalancer.ingress[0].ip}')/v2/
```
```
Hello, world!
Version: 2.0.0
Hostname: web-v2-fb7cb48f5-kkzkc
```

```bash
openssl genrsa -out ca.key 2048
openssl req -x509 -new -nodes -key ca.key -subj \
   "/CN=$(kubectl get svc -n nginx-ingress  nginx-ingress-controller  \
   -o jsonpath="{.status.loadBalancer.ingress[0].ip}")" -days 10000 -out ca.crt

kubectl create secret tls web-tls --key=ca.key --cert=ca.crt -n nginx-ingress

```

```yaml
  ## Additional command line arguments to pass to nginx-ingress-controller
  ## E.g. to specify the default SSL certificate you can use
  ## extraArgs:
  ##   default-ssl-certificate: "<namespace>/<secret_name>"
  extraArgs:
    default-ssl-certificate: "nginx-ingress/web-tls"

```

```bash
helm upgrade nginx-ingress stable/nginx-ingress -f values.yaml
#wait 30 seconds
openssl s_client -showcerts -connect 51.105.101.142:443
```
```
CONNECTED(00000003)
depth=0 CN = 51.105.101.142
verify error:num=18:self signed certificate
verify return:1
depth=0 CN = 51.105.101.142
verify return:1
---
Certificate chain
 0 s:/CN=51.105.101.142
   i:/CN=51.105.101.142

```