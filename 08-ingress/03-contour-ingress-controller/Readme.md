Deploy Contour Ingress
```bash
helm repo add rimusz https://charts.rimusz.net
helm repo updade
helm install --name contour-ingress rimusz/contour --namespace contour -f values.yaml
kubens contour
kubectl get pods
```
Deploy Sample Application

```bash
kubectl create ns sampleapp
kubens sampleapp
kubectl apply -f web-v1-fixed.yaml
kubectl apply -f web-v2-fixed.yaml
kubectl apply -f web-v1-svc.yaml
kubectl apply -f web-v2-svc.yaml
```

```
NAME                               READY   STATUS    RESTARTS   AGE
contour-ingress-67b588db67-qh5xt   2/2     Running   0          82s
```
```bash
kubectl get svc
```
```
NAME              TYPE           CLUSTER-IP     EXTERNAL-IP    PORT(S)                      AGE
contour-ingress   LoadBalancer   10.0.169.141   104.45.66.31   80:32001/TCP,443:30033/TCP   70s
```

References
- https://www.youtube.com/watch?v=764YUk-wSa0
- https://www.youtube.com/watch?v=O7HfkgzD7Z0
- - 