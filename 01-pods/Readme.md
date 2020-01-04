```bash
alias k=kubectl
kubectl apply -f 02-pod.yaml
kubectl delete -f 02-pod.yaml

kubectl port-forward kuard 8080:8080

kubectl apply -f 04-pods-resources.yaml
kubectl delete -f 04-pods-resources.yaml

kubectl apply -f 07-nodeselector.yaml
kubectl describe pod nginx
kubectl label node xxx cpu=kotu
kubectl get pods -w
kubectl delete -f 07-nodeselector.yaml
```

```bash
kubectl run nginx --image=nginx --restart=Never --command -it -- env
kubectl run nginx --image=nginx --restart=Never --command -it -- env > command-pod.yaml
kubectl apply -f command-pod.yaml
kubectl run nginx --image=nginx --restart=Never  --command --dry-run=true -o yaml
k run nginx --image=nginx --port=80 --dry-run=true -o yaml
kubectl set image pod/nginx nginx=nginx:1.7.9
kubectl get pods -o=jsonpath='{.items[*].spec.containers[*].image}{"\n"}'
```





#### Todo
- Quality of Service for Pods
- Projected Volume
- ImagePull Policy
- Private Registry
- Share Process Namespace between Containers in a Pod
- static pods
- kompose
- terminationGracePeriodSeconds
- terminationMessagePath: /dev/termination-log
- terminationMessagePolicy: File
