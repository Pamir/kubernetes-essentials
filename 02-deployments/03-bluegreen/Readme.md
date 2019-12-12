 kubectl create ns bluegreen
 kubectl apply -f app-v1.yaml
 kubectl run --restart=Never --image=raesene/alpine-nettools nettools
 kubectl exec -it nettools -- /bin/sh
 while true; do curl http://my-app.bluegreen; done

 kubectl apply -f app-v2.yaml
 kubectl get pods -n bluegreen
 kubectl patch service my-app -n bluegreen -p '{"spec":{"selector":{"version":"v2.0.0"}}}'

 kubectl delete ns bluegreen
 kubectl delete pod nettools