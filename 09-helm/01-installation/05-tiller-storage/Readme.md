```bash
helm install --name jenkins  stable/jenkins
kubectl get configmaps  jenkins.v1 -o yaml
helm delete --purge jenkins
helm reset --force

helm init --override 'spec.template.spec.containers[0].command'='{/tiller,--storage=secret}' --service-account tiller --max-history 200

```