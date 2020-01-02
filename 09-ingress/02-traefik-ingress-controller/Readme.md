```bash
helm install --name traefik stable/traefik --namespace traefik -f values.yaml
kubectl get pods -n traefik
kubectl get svc -n traefik
```

```
NAME                 TYPE           CLUSTER-IP     EXTERNAL-IP     PORT(S)                      AGE
traefik              LoadBalancer   10.0.201.17    104.45.75.216   80:30466/TCP,443:32393/TCP   9m29s
traefik-dashboard    ClusterIP      10.0.24.2      <none>          80/TCP                       9m29s
traefik-prometheus   ClusterIP      10.0.240.111   <none>          9100/TCP                     9m29s
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
```
NAME                      READY   STATUS    RESTARTS   AGE
web-v1-845d5c6978-6sgrl   1/1     Running   0          4h50m
web-v2-fb7cb48f5-kkzkc    1/1     Running   0          4h51m

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
    kubernetes.io/ingress.class: traefik
spec:
  rules:
  - http:
      paths:
      - path: /v2/
        backend:
          serviceName: web-v2
          servicePort: 8080
      - path: /v1/
        backend:
          serviceName: web-v1
          servicePort: 8080
```

Http Traffic

```bash
openssl genrsa -out ca.key 2048
openssl req -x509 -new -nodes -key ca.key -subj \
   "/CN=$(kubectl get svc -n traefik  traefik  \
   -o jsonpath="{.status.loadBalancer.ingress[0].ip}")" -days 10000 -out ca.crt

kubectl create secret tls web-tls --key=ca.key --cert=ca.crt -n traefik-ingress

```
cleanup
```bash
kubectl delete ns sampleapp
```
