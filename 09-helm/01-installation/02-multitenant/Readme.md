#### Namespace Installation
```bash
kubectl apply -f 01-tenant-ns.yaml
kubectl apply -f ../02-multitenant/
tiller init --service-account tiller --tiller-namespace tenant
```