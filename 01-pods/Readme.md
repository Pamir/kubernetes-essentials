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
