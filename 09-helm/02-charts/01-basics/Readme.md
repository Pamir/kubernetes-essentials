```bash
helm install --name jenkins stable/jenkins -f values.yaml --namespace jenkins
helm upgrade jenkins stable/jenkins -f values_updated.yaml
helm history jenkins
helm rollback jenkins 1
helm list
helm status jenkins
helm get jenkins 
helm delete jenkins
helm delete --purge jenkins
helm list
```

#### Good Bad and The Ugly

- image version
    - lts,latest
    - ImagePullPolicy
- Chart Location
- Chart version
