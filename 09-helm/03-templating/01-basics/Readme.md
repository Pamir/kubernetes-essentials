```bash
cd ~/dev/projects/charts 
helm template  mya-pp  -f my-app/values.yaml
```

- This way is more convinient if you have an operator framework in your deployment configuration like prometheus-operator
```bash
helm delete --purge myapp
helm install --name myapp . --dry-run --debug
```