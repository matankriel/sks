# SKS — OpenShift GitOps

GitOps repository for managing OpenShift namespaces and SecurityContextConstraints (SCCs) using Helm charts and ArgoCD ApplicationSets.

## Repository Structure

```
sks/
├── argocd/                          # ArgoCD ApplicationSet manifests
│   ├── appset-namespace-manager.yaml
│   └── appset-scc-manager.yaml
├── clusters/                        # Per-cluster Helm values
│   └── cluster-a/
│       ├── namespace-manager.yaml
│       └── scc-manager.yaml
├── helm-chart/                      # Namespace Manager Helm chart
└── scc-manager/                     # SCC Manager Helm chart
```

## Helm Charts

### `helm-chart` — Namespace Manager
Provisions a fully configured OpenShift namespace with:
- LDAP group sync (CronJob + ConfigMap + Secret)
- RBAC (RoleBinding, ClusterRole)
- ResourceQuota

### `scc-manager` — SCC Manager
Manages which service accounts are allowed to use specific OpenShift SecurityContextConstraints via RBAC bindings.

## ArgoCD ApplicationSets

Two ApplicationSets are defined under `argocd/`. Each uses a Git directory generator that watches `clusters/*`, so adding a new cluster directory automatically generates new ArgoCD Applications — no manifest changes required.

| ApplicationSet | Chart | App name pattern |
|---|---|---|
| `namespace-manager` | `helm-chart/` | `namespace-manager-<cluster>` |
| `scc-manager` | `scc-manager/` | `scc-manager-<cluster>` |

## Getting Started

### Prerequisites
- ArgoCD installed in the target cluster
- Cluster registered in ArgoCD (`argocd cluster add <name>`)

### 1. Set the repo URL

Replace `<REPO_URL>` in both ApplicationSet files with your actual Git remote:

```sh
# argocd/appset-namespace-manager.yaml
# argocd/appset-scc-manager.yaml
repoURL: https://github.com/matankriel/sks.git
```

### 2. Apply the ApplicationSets

```sh
kubectl apply -f argocd/ -n argocd
```

### 3. Verify

```sh
kubectl get applicationset -n argocd
argocd app list
# Expected: namespace-manager-cluster-a, scc-manager-cluster-a
```

### 4. Add a new cluster

Create a new subdirectory under `clusters/` with both values files:

```
clusters/
└── cluster-b/
    ├── namespace-manager.yaml
    └── scc-manager.yaml
```

The directory name must exactly match the cluster name registered in ArgoCD (`argocd cluster list`). ArgoCD will auto-generate new Applications on the next reconcile.

## Sync Policy

Both ApplicationSets are configured with:
- `automated.prune: true` — removes resources deleted from Git
- `automated.selfHeal: true` — reverts out-of-band changes
- `CreateNamespace=true` — ArgoCD creates the namespace if absent
