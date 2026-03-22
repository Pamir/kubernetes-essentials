# Advanced Kubernetes Features

This section covers advanced Kubernetes features for production-grade cluster management, including autoscaling, resource management, availability controls, and workload prioritization.

## Contents

### Autoscaling
- **HorizontalPodAutoscaler (HPA)**: Automatically scale pod replicas based on metrics
- **VerticalPodAutoscaler (VPA)**: Automatically adjust container resource requests/limits

### Resource Management  
- **ResourceQuota**: Control total resource consumption per namespace
- **LimitRange**: Set defaults and bounds for individual containers/pods
- **PriorityClass**: Define scheduling priority for workload preemption

### Availability & Disruption Management
- **PodDisruptionBudget (PDB)**: Ensure minimum availability during voluntary disruptions

## Files in this Section

### Autoscaling
- `01-hpa.yaml` - CPU/memory-based horizontal pod autoscaling with scaling policies
- `02-hpa-custom-metrics.yaml` - Advanced HPA using custom application metrics (RPS, queue depth)
- `03-vpa.yaml` - Vertical pod autoscaling for right-sizing container resources

### Resource Management
- `05-resource-quota.yaml` - Namespace-level resource quotas and object count limits
- `06-limit-range.yaml` - Container-level resource defaults, minimums, and maximums
- `07-priority-class.yaml` - Pod scheduling priorities for critical workload protection

### Availability
- `04-pdb.yaml` - Pod disruption budgets for different workload types

## Feature Overview

### HorizontalPodAutoscaler (HPA)
**Purpose**: Scale the number of pod replicas based on resource utilization or custom metrics

**Key Concepts**:
- **Metrics Types**: Resource (CPU/memory), Pods (per-pod metrics), Object (single object), External (cloud services)
- **Scaling Policies**: Control scale-up/scale-down speed and behavior
- **Stabilization Windows**: Prevent flapping by waiting between scaling decisions

**Requirements**: 
- Metrics Server installed
- Target deployment with resource requests
- Custom metrics adapter (for custom metrics)

### VerticalPodAutoscaler (VPA)  
**Purpose**: Automatically adjust CPU/memory requests and limits for containers

**Update Modes**:
- `Off`: Recommendations only (safe for production)
- `Auto`: Automatic updates with pod recreation
- `Initial`: Only for new pods
- `Recreation`: Legacy mode requiring restarts

**Use Cases**: Right-sizing workloads, cost optimization, performance tuning

### ResourceQuota
**Purpose**: Limit total resource consumption and object counts per namespace

**Quota Types**:
- **Compute**: Total CPU/memory requests and limits
- **Storage**: Persistent volume claim storage
- **Object Counts**: Pods, services, secrets, etc.
- **Scoped Quotas**: Different limits for different workload types

### LimitRange
**Purpose**: Set default, minimum, and maximum resource constraints for containers

**Enforcement Levels**:
- **Container**: Individual container limits
- **Pod**: Total pod resource limits  
- **PVC**: Persistent volume claim size limits

**Features**:
- Default resource injection
- Validation at admission time
- Limit-to-request ratios

### PodDisruptionBudget (PDB)
**Purpose**: Maintain minimum availability during voluntary disruptions

**Disruption Types**:
- **Voluntary**: Node drains, cluster upgrades, application updates
- **Involuntary**: Node failures, hardware issues (PDB doesn't help)

**Configuration**: `minAvailable` or `maxUnavailable` (absolute numbers or percentages)

### PriorityClass
**Purpose**: Define scheduling priority for pods to enable preemption

**Priority Ranges**:
- System Critical: 2000000000+ (DNS, kube-proxy)
- Production Critical: 1000000+ (customer-facing apps)
- Production Normal: 100000+ (regular workloads)
- Development: 0-99999 (dev/test)
- Batch: < 0 (background jobs)

## Architecture Patterns

### Complete Resource Governance
```
Namespace
├── ResourceQuota (total limits)
├── LimitRange (individual defaults/limits) 
├── PriorityClass (scheduling priority)
└── PodDisruptionBudget (availability protection)
```

### Autoscaling Strategy
```
Application
├── HPA (horizontal scaling for traffic)
├── VPA (vertical scaling for efficiency)  
├── PDB (availability during scaling)
└── PriorityClass (resource competition)
```

## Best Practices

### Autoscaling
1. **Start Conservative**: Begin with higher thresholds, tune down based on behavior
2. **Combine HPA + VPA**: HPA for quick response, VPA for long-term efficiency
3. **Monitor Metrics**: Ensure metrics are accurate and representative
4. **Test Scaling**: Validate scaling behavior under load

### Resource Management
1. **Layered Approach**: Use ResourceQuota + LimitRange together
2. **Environment-Specific**: Different limits for dev/staging/prod
3. **Monitor Usage**: Adjust quotas based on actual consumption patterns
4. **Default Requests**: Always provide reasonable resource defaults

### Availability
1. **Match Update Strategy**: Align PDB with deployment rolling update settings  
2. **Consider Dependencies**: Account for service topology in PDB configuration
3. **Test Disruptions**: Validate PDB effectiveness during simulated maintenance
4. **Priority Alignment**: Higher priority workloads should have stricter PDBs

## Troubleshooting

### HPA Issues
```bash
# Check HPA status
kubectl get hpa
kubectl describe hpa my-hpa

# Check metrics availability  
kubectl top pods
kubectl get --raw /apis/metrics.k8s.io/v1beta1/pods
```

### Resource Issues
```bash
# Check resource quota status
kubectl describe quota -n namespace
kubectl get limitrange -n namespace

# Find resource-constrained pods
kubectl get events --field-selector reason=FailedScheduling
```

### PDB Issues  
```bash
# Check PDB status
kubectl get pdb
kubectl describe pdb my-pdb

# Check for eviction blocks
kubectl get events --field-selector reason=EvictionBlocked
```

## Monitoring & Alerting

### Key Metrics
- **HPA**: Current/target replicas, metric values, scaling events
- **VPA**: Recommendation vs actual resources, update events  
- **ResourceQuota**: Usage vs limits across all resource types
- **PDB**: Available vs desired pods, disruption events

### Common Alerts
- HPA unable to scale due to resource constraints
- ResourceQuota approaching limits
- PDB preventing necessary maintenance operations
- VPA recommendations significantly different from current allocation