# Cluster Management Commands

## Basic Cluster Info
```bash
# Get cluster information
kubectl cluster-info
kubectl component-statuses
kubectl api-resources
kubectl api-versions

# Node information
kubectl get nodes
kubectl get nodes -o wide
kubectl top nodes  # Resource usage (requires metrics server)
```

## Context Management
```bash
# View available contexts
kubectl config get-contexts

# Switch context
kubectl config use-context <context-name>

# View current context
kubectl config current-context
```

## Namespace Management
```bash
# Create namespace
kubectl create namespace <namespace-name>

# List namespaces
kubectl get namespaces

# Set default namespace for current context
kubectl config set-context --current --namespace=<namespace-name>

# Delete namespace (and all resources in it)
kubectl delete namespace <namespace-name>
```

## Resource Management
```bash
# Apply configuration
kubectl apply -f <file.yaml>
kubectl apply -f <directory>/

# Get resources
kubectl get <resource-type>
kubectl get <resource-type> -n <namespace>
kubectl get <resource-type> -o yaml
kubectl get <resource-type> -o wide

# Describe resources (detailed info)
kubectl describe <resource-type> <resource-name>

# Delete resources  
kubectl delete <resource-type> <resource-name>
kubectl delete -f <file.yaml>
```