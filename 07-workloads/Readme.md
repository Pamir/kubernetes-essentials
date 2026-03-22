# Kubernetes Workloads

This section covers the different types of workloads you can run in Kubernetes. Each workload type serves specific use cases and provides different guarantees about pod lifecycle, networking, and storage.

## Contents

### 01-daemonset/
DaemonSets ensure that a copy of a pod runs on every node (or selected nodes) in the cluster.
**Use cases:** System daemons, log collection, monitoring agents, storage daemons
**Key features:** Node affinity, automatic scaling with cluster, privileged containers

### 02-job/
Jobs run pods to completion for batch work and one-time tasks.
**Use cases:** Database migrations, batch processing, backup tasks, data import/export
**Key features:** Parallel execution, retry logic, completion tracking, cleanup policies

### 03-cronjob/
CronJobs run Jobs on a time-based schedule using cron syntax.
**Use cases:** Scheduled backups, report generation, cleanup tasks, health checks
**Key features:** 
- Cron scheduling syntax (minute hour day month weekday)
- Concurrency policies (Allow, Forbid, Replace)
- History limits for debugging
- Timezone support
- Job template configuration

Files:
- `01-cronjob.yaml` - Simple CronJob running every 5 minutes
- `02-cronjob-backup.yaml` - Production database backup with error handling

### 04-statefulset/
StatefulSets manage pods that need stable network identities and persistent storage.
**Use cases:** Databases, distributed systems, clustered applications requiring ordered deployment
**Key features:**
- Stable, unique network identities (predictable pod names)
- Stable, persistent storage (each pod gets its own PVC)
- Ordered, graceful deployment and scaling
- Ordered, automated rolling updates

Files:
- `01-statefulset.yaml` - Nginx StatefulSet with persistent storage
- `02-headless-service.yaml` - Headless service required for StatefulSet DNS

## Workload Selection Guide

| Workload Type | Use When | Pod Names | Storage | Network Identity |
|---------------|----------|-----------|---------|------------------|
| **Deployment** | Stateless apps | Random | Ephemeral | Load-balanced |
| **StatefulSet** | Stateful apps | Predictable (pod-0, pod-1) | Persistent per pod | Individual DNS names |
| **DaemonSet** | Node-level services | Node-based | Usually host-mounted | Node IP |
| **Job** | Batch/one-time tasks | Random | Ephemeral | Temporary |
| **CronJob** | Scheduled tasks | Random | Ephemeral | Temporary |

## Best Practices

1. **Resource Limits**: Always set resource requests and limits
2. **Health Checks**: Configure readiness and liveness probes
3. **Security**: Use non-root users and read-only file systems when possible
4. **Monitoring**: Add appropriate labels for observability
5. **Graceful Shutdown**: Set appropriate `terminationGracePeriodSeconds`

## Common Patterns

- **Database Clusters**: StatefulSet + Headless Service + PVCs
- **Background Jobs**: CronJob with appropriate retry policies
- **System Services**: DaemonSet with node selectors
- **Batch Processing**: Job with parallelism and completion tracking