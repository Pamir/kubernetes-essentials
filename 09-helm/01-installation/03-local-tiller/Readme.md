#### Installing Tiller Locally
```bash
tiller &
export HELM_HOST=localhost:44134
helm create sample-chart
cd sample-chart
helm install --name sample . -f values.yaml
helm install --name sample --dry-run --debug .
helm lint .
```

#### Important Notes
```
[tiller] 2019/12/14 22:05:18 preparing install for 
[storage] 2019/12/14 22:05:18 getting release "unrealistic-zebu.v1"
[tiller] 2019/12/14 22:05:19 info: Created new release name unrealistic-zebu
[tiller] 2019/12/14 22:05:21 failed install prepare step: Could not get apiVersions from Kubernetes: unable to retrieve the complete list of server APIs: custom.metrics.k8s.io/v1beta1: the server is currently unable to handle the request
```
- https://github.com/helm/helm/issues/6361