```bash
helm install --name prometheues stable/prometheus-operator --namespace monitoring -f values.yaml
kubectl apply -f aks-kubelet-service-monitor.yaml -n monitoring
```
