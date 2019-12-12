#### Spinnaker v1 Legacy Style Canary Deployment

```bash
kubectl apply -f 01-deployment.yaml 
kubectl exec -it nettools -- /bin/sh
while true; do curl --connect-timeout 1 -m 1 http://my-app; done
kubectl apply -f 02-deployment.yaml
```

#### Cleanup
```bash
kubectl delete -f  01-deployment.yaml
kubectl delete -f 02-deployment.yaml
```