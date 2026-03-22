# Kubernetes Essentials — Zero to Hero Workshop

[![Kubernetes](https://img.shields.io/badge/kubernetes-%23326ce5.svg?style=for-the-badge&logo=kubernetes&logoColor=white)](https://kubernetes.io/)
[![Azure](https://img.shields.io/badge/azure-%230072C6.svg?style=for-the-badge&logo=microsoftazure&logoColor=white)](https://azure.microsoft.com/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg?style=for-the-badge)](https://opensource.org/licenses/MIT)
[![Workshop](https://img.shields.io/badge/Type-Workshop-green?style=for-the-badge)](.)

A comprehensive hands-on workshop to learn Kubernetes from the ground up. This workshop covers everything from basic concepts to advanced patterns, with practical exercises and real-world scenarios using Azure Kubernetes Service (AKS).

## 📖 Table of Contents

- [🚀 Quick Start: Create an AKS Cluster](#-quick-start-create-an-aks-cluster)
- [📋 Workshop Modules](#-workshop-modules)
- [🛠️ Prerequisites & Tools](#️-prerequisites--tools)
- [📚 Learning Resources](#-learning-resources)
- [🧹 Cleanup](#-cleanup)
- [📄 License](#-license)

## 🚀 Quick Start: Create an AKS Cluster

### Bash Script (Linux/macOS/WSL)

```bash
#!/bin/bash

# =============================================================================
# Production-Ready AKS Cluster Creation Script
# =============================================================================

# Cluster Configuration Variables
RG="rg-k8s-workshop"              # Resource Group name
CLUSTER="aks-workshop"            # AKS cluster name
LOCATION="westeurope"             # Azure region (choose closest to you)
NODE_COUNT=3                      # Initial number of worker nodes
NODE_SIZE="Standard_D2s_v5"       # VM size for nodes (2 vCPU, 8GB RAM)
K8S_VERSION="1.29"                # Kubernetes version

echo "🚀 Creating AKS cluster: $CLUSTER in $LOCATION"

# Create Resource Group
echo "📦 Creating resource group..."
az group create --name $RG --location $LOCATION

# Create AKS Cluster with Production Best Practices
echo "⚙️ Creating AKS cluster (this may take 5-10 minutes)..."
az aks create \
    --resource-group $RG \
    --name $CLUSTER \
    --location $LOCATION \
    --node-count $NODE_COUNT \
    --node-vm-size $NODE_SIZE \
    --kubernetes-version $K8S_VERSION \
    --network-plugin azure \              # Use Azure CNI for better performance
    --network-policy calico \             # Enable Calico network policies
    --generate-ssh-keys \                 # Auto-generate SSH keys
    --enable-managed-identity \           # Use managed identity (more secure)
    --enable-addons monitoring \          # Enable Azure Monitor for containers
    --enable-cluster-autoscaler \         # Enable cluster autoscaler
    --min-count 1 \                       # Minimum nodes for autoscaler
    --max-count 5 \                       # Maximum nodes for autoscaler
    --zones 1 2 3 \                       # Spread across availability zones
    --tier standard \                     # Standard tier for SLA
    --os-sku AzureLinux \                # Use Azure Linux (optimized)
    --auto-upgrade-channel stable \       # Enable automatic upgrades
    --tags environment=workshop purpose=learning

# Get cluster credentials and configure kubectl
echo "🔐 Configuring kubectl..."
az aks get-credentials --resource-group $RG --name $CLUSTER --overwrite-existing

# Verify cluster is working
echo "✅ Verifying cluster..."
kubectl get nodes
echo ""
kubectl cluster-info
echo ""
echo "🎉 AKS cluster '$CLUSTER' is ready!"
echo "💡 Run 'kubectl get namespaces' to see default namespaces"
```

### PowerShell Script (Windows)

```powershell
# =============================================================================
# Production-Ready AKS Cluster Creation Script (PowerShell)
# =============================================================================

# Cluster Configuration Variables
$RG = "rg-k8s-workshop"              # Resource Group name
$CLUSTER = "aks-workshop"            # AKS cluster name
$LOCATION = "westeurope"             # Azure region (choose closest to you)
$NODE_COUNT = 3                      # Initial number of worker nodes
$NODE_SIZE = "Standard_D2s_v5"       # VM size for nodes (2 vCPU, 8GB RAM)
$K8S_VERSION = "1.29"                # Kubernetes version

Write-Host "🚀 Creating AKS cluster: $CLUSTER in $LOCATION" -ForegroundColor Green

# Create Resource Group
Write-Host "📦 Creating resource group..." -ForegroundColor Yellow
az group create --name $RG --location $LOCATION

# Create AKS Cluster with Production Best Practices
Write-Host "⚙️ Creating AKS cluster (this may take 5-10 minutes)..." -ForegroundColor Yellow
az aks create `
    --resource-group $RG `
    --name $CLUSTER `
    --location $LOCATION `
    --node-count $NODE_COUNT `
    --node-vm-size $NODE_SIZE `
    --kubernetes-version $K8S_VERSION `
    --network-plugin azure `              # Use Azure CNI for better performance
    --network-policy calico `             # Enable Calico network policies
    --generate-ssh-keys `                 # Auto-generate SSH keys
    --enable-managed-identity `           # Use managed identity (more secure)
    --enable-addons monitoring `          # Enable Azure Monitor for containers
    --enable-cluster-autoscaler `         # Enable cluster autoscaler
    --min-count 1 `                       # Minimum nodes for autoscaler
    --max-count 5 `                       # Maximum nodes for autoscaler
    --zones 1 2 3 `                       # Spread across availability zones
    --tier standard `                     # Standard tier for SLA
    --os-sku AzureLinux `                # Use Azure Linux (optimized)
    --auto-upgrade-channel stable `       # Enable automatic upgrades
    --tags environment=workshop purpose=learning

# Get cluster credentials and configure kubectl
Write-Host "🔐 Configuring kubectl..." -ForegroundColor Yellow
az aks get-credentials --resource-group $RG --name $CLUSTER --overwrite-existing

# Verify cluster is working
Write-Host "✅ Verifying cluster..." -ForegroundColor Yellow
kubectl get nodes
Write-Host ""
kubectl cluster-info
Write-Host ""
Write-Host "🎉 AKS cluster '$CLUSTER' is ready!" -ForegroundColor Green
Write-Host "💡 Run 'kubectl get namespaces' to see default namespaces" -ForegroundColor Cyan
```

## 📋 Workshop Modules

| Module | Topic | Description |
|--------|-------|-------------|
| **00-cluster** | Cluster Setup & Namespaces | AKS creation, kubectl basics, namespace management |
| **01-pods** | Pod Fundamentals | Pod lifecycle, health checks, resource limits, volumes, init containers |
| **02-deployments** | Deployments & Strategies | Rolling updates, rollbacks, blue-green, canary deployments |
| **03-labels-annotations** | Metadata Management | Labels, selectors, annotations, and organizational patterns |
| **04-services** | Service Discovery | ClusterIP, NodePort, LoadBalancer, ExternalName services |
| **05-configmaps-secrets** | Configuration Management | Externalized config, secret management, volume mounts |
| **06-storage** | Persistent Storage | Ephemeral storage, PV/PVC, StorageClasses, Azure Disk/Files |
| **07-workloads** | Advanced Workloads | DaemonSets, Jobs, CronJobs, StatefulSets |
| **08-helm** | Package Management | Helm charts, repositories, templating, lifecycle management |
| **09-ingress** | Traffic Management | NGINX, Traefik, Contour controllers, SSL termination |
| **10-monitoring** | Observability | Prometheus, Grafana, Azure Monitor, logging strategies |
| **11-security** | Security & Compliance | RBAC, NetworkPolicies, PodSecurityStandards, ServiceAccounts |
| **12-advanced** | Scaling & Reliability | HPA/VPA, PodDisruptionBudgets, ResourceQuotas, LimitRanges |
| **13-service-mesh** | Service Mesh (NEW) | Istio basics, traffic management, security policies |

## 🛠️ Prerequisites & Tools

### Required Tools

**Core Kubernetes Tools:**
- [kubectl](https://kubernetes.io/docs/tasks/tools/) - Kubernetes command-line tool
- [kubectx/kubens](https://github.com/ahmetb/kubectx) - Context and namespace switching
- [k9s](https://k9scli.io/) - Terminal-based UI for Kubernetes
- [Lens](https://k8slens.dev/) - Desktop IDE for Kubernetes

**Cloud & Infrastructure:**
- [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli) - Azure command-line interface
- [Helm](https://helm.sh/docs/intro/install/) - Kubernetes package manager

**Development Tools:**
- [VS Code](https://code.visualstudio.com/) with [Kubernetes extension](https://marketplace.visualstudio.com/items?itemName=ms-kubernetes-tools.vscode-kubernetes-tools)
- [Docker Desktop](https://www.docker.com/products/docker-desktop) (optional, for local development)

### Useful Aliases & Shortcuts

```bash
# Add to ~/.bashrc or ~/.zshrc
alias k='kubectl'
alias kns='kubens'
alias kctx='kubectx'
alias kgp='kubectl get pods'
alias kgs='kubectl get svc'
alias kgd='kubectl get deployment'
alias kdp='kubectl describe pod'
alias kds='kubectl describe svc'
alias kdd='kubectl describe deployment'

# Enable kubectl bash completion
source <(kubectl completion bash)
# For zsh users:
# source <(kubectl completion zsh)
```

### PowerShell Aliases (Windows)

```powershell
# Add to PowerShell profile
Set-Alias -Name k -Value kubectl
function kgp { kubectl get pods $args }
function kgs { kubectl get svc $args }
function kgd { kubectl get deployment $args }
function kdp { kubectl describe pod $args }
function kds { kubectl describe svc $args }
function kdd { kubectl describe deployment $args }
```

## 📚 Learning Resources

### Official Documentation
- [Kubernetes Documentation](https://kubernetes.io/docs/)
- [Azure Kubernetes Service (AKS)](https://docs.microsoft.com/en-us/azure/aks/)
- [kubectl Cheat Sheet](https://kubernetes.io/docs/reference/kubectl/cheatsheet/)

### Books & Tutorials
- [Kubernetes: Up and Running](https://azure.microsoft.com/en-us/resources/kubernetes-up-and-running/)
- [The Kubernetes Book](https://leanpub.com/thekubernetesbook)
- [AKS Workshop](https://aksworkshop.io/)

### Interactive Learning
- [Kubernetes Learning Path](https://azure.microsoft.com/en-us/resources/kubernetes-learning-path/)
- [Play with Kubernetes](https://labs.play-with-k8s.com/)
- [Katacoda Kubernetes Scenarios](https://www.katacoda.com/courses/kubernetes)

### Community & Tools
- [kubectl-aliases](https://github.com/ahmetb/kubectl-aliases) - Comprehensive kubectl aliases
- [kube-ps1](https://github.com/jonmosco/kube-ps1) - Kubernetes prompt for bash/zsh
- [kube-forwarder](https://www.electronjs.org/apps/kube-forwarder) - Easy port forwarding GUI

## 🧹 Cleanup

When you're done with the workshop, clean up your Azure resources to avoid charges:

### Bash/PowerShell
```bash
# Delete the entire resource group (this removes everything)
az group delete --name rg-k8s-workshop --yes --no-wait

# Or just delete the AKS cluster
az aks delete --resource-group rg-k8s-workshop --name aks-workshop --yes --no-wait
```

### Verify Cleanup
```bash
# List resource groups to confirm deletion
az group list --output table
```

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

**Happy Learning! 🚀**

*This workshop is designed to take you from Kubernetes zero to hero. Each module builds upon the previous one, so it's recommended to follow them in order. Don't hesitate to experiment and break things - that's how we learn best!*
