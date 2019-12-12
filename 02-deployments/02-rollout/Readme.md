```bash
kubectl apply -f nginx-deployment.yaml

#watch the status of deployment
kubectl rollout status deployment.v1.apps/nginx-deployment
```
### Deployment History
```bash
kubectl set image deployment/nginx-deployment nginx=nginx:1.9.1 --record
#or 
kubectl edit deployment nginx-deployment

kubectl rollout status deployment.v1.apps/nginx-deployment
kubectl get deployments
kubectl get rs
kubectl describe deployment nginx-deployment
```

### Rolling Back a Deployment
```bash 
kubectl set image deployment.v1.apps/nginx-deployment nginx=nginx:1.91 --record=true
kubectl rollout status deployment.v1.apps/nginx-deployment
kubectl get rs
kubectl get pods
kubectl describe deployment nginx-deployment
# details of the revision
kubectl rollout history deployment.v1.apps/nginx-deployment
kubectl rollout history deployment.v1.apps/nginx-deployment --revision=2
# rollout undo deployment
kubectl rollout undo deployment.v1.apps/nginx-deployment
kubectl rollout undo deployment.v1.apps/nginx-deployment --to-revision=2
```

### Pause Deployment
```bash
kubectl rollout pause deployment nginx-deployment 
kubectl set image deployment nginx-deployment nginx=nginx:1.7.9
kubectl rollout history deployment nginx-deployment
kubectl get rs
kubectl set resources deployment nginx-deployment -c=nginx --limits=memory=256
kubectl rollout resume deployment nginx-deployment
```
