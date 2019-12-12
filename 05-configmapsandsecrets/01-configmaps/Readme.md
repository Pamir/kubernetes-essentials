```bash
kubectl apply -f kubectl create configmap game-config --from-file=../
kubectl describe configmaps game-config
kubectl get configmaps game-config -o yaml

```