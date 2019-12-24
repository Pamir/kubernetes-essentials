### wcgw
```bash
kubectl create ns redis
kubectl apply -f 01-redis-template.yaml
kubectl get pods -n redis
kubectl get pvc -n redis
kubectl get pv
kubectl exec -it redis-master-0   -- /bin/sh
redis-cli
set name pamir
127.0.0.1:6379> get name
"pamir"
exit
exit
kubectl delete -f 01-redis-template.yaml
kubectl apply -f 02-redis-template.yaml
kubectl exec -it redis-master-0  -n redis  -- /bin/sh
# redis-cli
127.0.0.1:6379> get name
"pamir"
127.0.0.1:6379> exit
# exit
kubectl delete -f r02-redis-template.yaml
kubectl apply -f 03-redis-template.yaml
```