#### Generic Secrets
Not for Production patterns. Instead of using secrets try to use Vault Systems

```bash
kubectl create secret generic dev-db-secret --from-literal=username=devuser --from-literal=password='123456'
kubectl get secret dev-db-secret -o yaml
kubectl apply -f 01-secret-sample.yaml 
kubectl get pods
kubectl exec -it pod2  -- env | grep PASS
kubectl delete secret dev-db-secret
kubectl delete -f 01-secret-sample.yaml
```

```bash
kubectl create secret generic user-pass --from-file=userpass
kubectl get secret
kubectl get secret user-pass  -o yaml
kubectl apply -f 02-secret-sample.yaml
kubectl exec -it pod2 -- cat /var/configration/userpass
```

```yaml
apiVersion: v1
data:
  userpass: dXNlcm5hbWU9bXNkZXZlbmdlcnMKcGFzc3dvcmQ9MTIzNDU2
kind: Secret
metadata:
  creationTimestamp: "2019-12-21T17:58:10Z"
  name: user-pass
  namespace: default
  resourceVersion: "560828"
  selfLink: /api/v1/namespaces/default/secrets/user-pass
  uid: 94086743-8180-4cce-997d-143bb5875953
type: Opaque
```
```bash
kubectl get secrets/user-pass --template={{.data.userpass}}  | base64 -D
```
CleanUp
```bash
kubectl delete -f 02-secret-sample.yaml
kubectl delete secret user-pass
```


#### Image Secrets
```bash
kubectl create secret docker-registry repository-secret \
    --docker-server=docker.io --docker-username=devengers \
    --docker-password=123456 --docker-email=devengers@dev.com
kubectl apply -f 03-secret-sample.yaml
```

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: pod2
spec:
  containers:
  - name: nginx
    image: nginx
  imagePullSecrets:
    - repository-secret
```
Cleanup
```bash
kubectl delete -f 03-secret-sample.yaml
kubectl delete secret docker-registry
```

#### TLS Secrets
```bash
openssl req -newkey rsa:2048 -nodes -keyout jenkins.key -x509 -days 365 -out cenkins.crt
kubectl create secret tls jenkins-tls-secret --key=jenkins.key --cert=jenkins.crt
kubectl get secret
```

```
NAME                            TYPE                                  DATA   AGE
default-token-6p7c5             kubernetes.io/service-account-token   3      3d21h
dev-db-secret                   Opaque                                2      25m
jenkins-tls-secret              kubernetes.io/tls                     2      7s
reloader-reloader-token-rdd45   kubernetes.io/service-account-token   3      58m
user-pass                       Opaque                                1      37m
```

```bash
kubectl get pods 
```
```
NAME                                 READY   STATUS    RESTARTS   AGE
nginx-7476885559-w9bp9               1/1     Running   0          2m7s
pod2                                 1/1     Running   0          24m
reloader-reloader-79784f86c7-kzpml   1/1     Running   0          62m
```

```bash
kubectl exec -it nginx-7476885559-w9bp9  -- ls /usr/src/nginx/tls
```