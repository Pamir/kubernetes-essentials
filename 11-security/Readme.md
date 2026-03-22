# Kubernetes Security

Security in Kubernetes involves multiple layers of protection: authentication, authorization, admission control, network security, and runtime security. This section covers the essential security concepts and configurations.

## Core Security Concepts

### 1. Authentication & Authorization (RBAC)
- **ServiceAccounts**: Identity for pods to access the Kubernetes API
- **Roles**: Define permissions within a specific namespace  
- **ClusterRoles**: Define cluster-wide permissions
- **RoleBindings**: Grant Role permissions to users/groups/service accounts in a namespace
- **ClusterRoleBindings**: Grant ClusterRole permissions across the entire cluster

### 2. Network Security
- **NetworkPolicies**: Control traffic flow between pods using label selectors
- **Default Deny**: Security best practice to block all traffic by default
- **Micro-segmentation**: Implement least-privilege network access

### 3. Pod Security
- **Security Contexts**: Configure security settings at pod and container level
- **Pod Security Standards**: Kubernetes-native admission control (Privileged, Baseline, Restricted)
- **Capabilities**: Fine-grained control over Linux kernel capabilities

## Files in this Section

### RBAC (Role-Based Access Control)
- `01-rbac-role.yaml` - Namespace-scoped permissions for pod access
- `02-rbac-rolebinding.yaml` - Bind roles to users, groups, and service accounts  
- `03-rbac-clusterrole.yaml` - Cluster-wide permissions for monitoring and admin access
- `04-serviceaccount.yaml` - Identity management for pods and applications

### Network Security  
- `05-networkpolicy-deny-all.yaml` - Default deny policies for baseline security
- `06-networkpolicy-allow-frontend.yaml` - Allow specific frontend-to-backend communication
- `07-networkpolicy-egress.yaml` - Control outbound traffic to external services

### Pod Security
- `08-pod-security-restricted.yaml` - Secure pod configuration with security contexts
- `09-pod-security-admission.yaml` - Namespace-level Pod Security Standards configuration

## Security Best Practices

### RBAC Best Practices
1. **Principle of Least Privilege**: Grant minimal required permissions
2. **Use Service Accounts**: Don't use default service account for applications
3. **Namespace Isolation**: Use Roles instead of ClusterRoles when possible
4. **Regular Audits**: Review and rotate permissions regularly

### Network Security Best Practices
1. **Default Deny**: Start with deny-all NetworkPolicies, then add specific allows
2. **Label Strategy**: Use consistent labels for NetworkPolicy selectors
3. **Egress Control**: Control outbound traffic to prevent data exfiltration
4. **DNS Security**: Always allow DNS (port 53) in egress policies

### Pod Security Best Practices
1. **Non-Root Users**: Always run containers as non-root (`runAsNonRoot: true`)
2. **Read-Only Root FS**: Use `readOnlyRootFilesystem: true` when possible
3. **Drop Capabilities**: Drop all capabilities (`drop: ["ALL"]`), add only what's needed
4. **Security Profiles**: Use `seccompProfile: RuntimeDefault`
5. **Resource Limits**: Set CPU and memory limits to prevent resource exhaustion

### Security Context Hierarchy
```
Pod Security Context (applies to all containers)
↓
Container Security Context (overrides pod-level for specific container)
```

## Common RBAC Patterns

| Role Type | Scope | Use Case | Example |
|-----------|-------|----------|---------|
| **Role** | Namespace | App-specific permissions | Developer access to dev namespace |
| **ClusterRole** | Cluster | Cross-namespace or cluster resources | Monitoring system, cluster admin |
| **Built-in ClusterRole** | Cluster | Common permission sets | `view`, `edit`, `admin`, `cluster-admin` |

### Built-in ClusterRoles
- `view`: Read-only access to most objects
- `edit`: Read/write access to most objects (not RBAC)  
- `admin`: Full access to namespace (including RBAC)
- `cluster-admin`: Full cluster access (use sparingly!)

## NetworkPolicy Selectors

### Pod Selection
```yaml
podSelector:
  matchLabels:
    app: backend    # Select pods with app=backend
```

### Namespace Selection  
```yaml
namespaceSelector:
  matchLabels:
    name: production  # Select namespaces with name=production
```

### IP Block Selection
```yaml
ipBlock:
  cidr: 10.0.0.0/8     # Allow IP range
  except:
  - 10.1.0.0/16        # Except this subnet
```

## Pod Security Standards

| Profile | Description | Use Case |
|---------|-------------|----------|
| **Privileged** | Unrestricted | Legacy apps, system components |
| **Baseline** | Minimally restrictive | General applications |
| **Restricted** | Heavily restricted | High-security environments |

### Migration Strategy
1. Start with **Privileged** (current state)
2. Move to **Baseline** (warn + audit first, then enforce)  
3. Target **Restricted** for production workloads
4. Use namespace labels to control enforcement

## Troubleshooting Security Issues

### RBAC Debugging
```bash
# Check if user can perform action
kubectl auth can-i get pods --as=system:serviceaccount:default:my-sa

# Check effective permissions
kubectl describe rolebinding,clusterrolebinding

# Check service account token
kubectl describe serviceaccount my-sa
```

### NetworkPolicy Debugging  
```bash
# Check if NetworkPolicy selects pod
kubectl describe networkpolicy my-policy

# Check pod labels
kubectl get pods --show-labels

# Test connectivity
kubectl exec -it pod1 -- nc -zv pod2-ip 8080
```

### Security Context Issues
```bash
# Check pod security context
kubectl describe pod my-pod

# Check container user
kubectl exec -it my-pod -- id

# Check filesystem permissions
kubectl exec -it my-pod -- ls -la /
```