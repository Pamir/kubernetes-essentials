```bash
kubectl create configmap simple-config --from-literal=name=msdevengers --from-literal=source=github
kubectl get configmap simple-config -o yaml 
kubectl describe configmap simple-config
kubectl delete configmap simple-config
```

```bash
cat config.txt
kubectl create configmap simple-config --from-file=config.txt
kubectl get configmap simple-config -o yaml 
kubectl describe configmap simple-config
kubectl delete configmap simple-config
```
```bash
kubectl create configmap simple-config --from-env-file=config.txt 
kubectl get configmap simple-config -o yaml 
kubectl describe configmap simple-config
kubectl delete configmap simple-config
```

```bash
kubectl create configmap simple-config --from-file=config=config.txt
kubectl get cm -o yaml simple-config
kubectl delete configmap simple-config
```
```bash
kubectl create cm simple-config --from-literal=name=msdevengers
kubectl apply -f 02-configmap-sample.yaml 
```

```bash
kubectl delete configmap simple-config
kubectl delete pod nginx
```


```bash
kubectl create configmap log4j-config --from-file=log4j.xml
kubectl apply -f 03-javaapp-pod.yaml 
kubectl exec -it javaapp  -- /bin/sh ls -lart /var/configuration
```

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: javaapp
spec:
  containers:
  - name: nginx
    image: nginx
    volumeMounts:
    - mountPath: /var/configuration
      name: log4j-volume
  volumes:
    - name: log4j-volume 
      configMap:
        name: log4j-config
```

```bash
kubectl delete -f 03-javaapp-pod.yaml 
kubectl delete configmap log4j-config 
```

```bash
## BINGO
kubectl apply -f https://raw.githubusercontent.com/stakater/Reloader/master/deployments/kubernetes/reloader.yaml
kubectl create configmap log4j-config --from-file=log4j.xml
kubectl apply -f 04-javaapp-pod.yaml 
```
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  creationTimestamp: null
  labels:
    run: javaapp
  name: javaapp
  annotations:
    configmap.reloader.stakater.com/reload: "log4j-config"
```
```bash
kubectl edit configmap log4j-congig
```

```xml
        <logger name="org.quartz">
            <level value="ERROR" />
        </logger>

        <logger name="org.quartz">
            <level value="DEBUG" />
        </logger>
```

```bash
watch -n5 kubectl get pods
kubectl delete configmap log4j-config
kubectl delete deployment javaapp
kubectl delete -f https://raw.githubusercontent.com/stakater/Reloader/master/deployments/kubernetes/reloader.yaml
```

References
- https://github.com/stakater/Reloader
- https://azure.microsoft.com/en-us/resources/kubernetes-up-and-running/
- https://kubernetes.io/docs/tasks/configure-pod-container/configure-pod-configmap/