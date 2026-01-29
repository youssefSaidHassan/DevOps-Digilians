Kubernetes Manifests for Digilians
===================================

## Overview
- **Backend Namespace**: `digilians-backend` (Backend Deployment, StatefulSet DB, Services, Secrets)
- **Frontend Namespace**: `digilians-frontend` (Frontend Deployment, Services)
- **Concepts Covered**: Namespaces, Deployments (replicas: 3), Services, StatefulSet, Secrets, RBAC, StorageClass (Rancher), PVCs

## Quick Start - Step by Step

### Step 1: Start Minikube
```bash
minikube start --driver=docker
```

### Step 2: Create Namespaces
```bash
kubectl apply -f k8s/namespaces/dev-namespace.yaml
```
This creates both `digilians-backend` and `digilians-frontend` namespaces.

### Step 3: Create Registry Secrets (for Private Images)
Replace `<YOUR_REGISTRY>`, `<USER>`, `<PASS>`, and `<EMAIL>` with your actual values:

```bash
# Backend registry secret
kubectl create secret docker-registry regcred \
  --docker-server=<YOUR_REGISTRY> \
  --docker-username=<USER> \
  --docker-password=<PASS> \
  --docker-email=<EMAIL> \
  -n digilians-backend

# Frontend registry secret
kubectl create secret docker-registry regcred \
  --docker-server=<YOUR_REGISTRY> \
  --docker-username=<USER> \
  --docker-password=<PASS> \
  --docker-email=<EMAIL> \
  -n digilians-frontend
```

### Step 4: Update Deployment Images
Edit the image URLs in:
- `k8s/deployments/backend-deployment.yaml` (line with `image: <YOUR_REGISTRY>/...`)
- `k8s/deployments/frontend-deployment.yaml` (line with `image: <YOUR_REGISTRY>/...`)

Replace `<YOUR_REGISTRY>` with your private registry (e.g., `docker.io/myusername` or `gcr.io/myproject`).

### Step 5: Apply All Manifests
```bash
chmod +x k8s/apply-all.sh
./k8s/apply-all.sh
```

## Verify Deployment

Check that everything is running:

```bash
# Check backend resources
kubectl get all -n digilians-backend
kubectl get pvc -n digilians-backend

# Check frontend resources
kubectl get all -n digilians-frontend

# Check pod details
kubectl describe pods -n digilians-backend
kubectl describe pods -n digilians-frontend

# View logs
kubectl logs -l app=backend -n digilians-backend
kubectl logs -l app=frontend -n digilians-frontend

# Access services (within cluster or via port-forward)
kubectl port-forward svc/backend-service 8000:8000 -n digilians-backend
kubectl port-forward svc/frontend-service 3000:80 -n digilians-frontend
```

## Folder Structure
```
k8s/
├── namespaces/
│   └── dev-namespace.yaml          # Both digilians-backend and digilians-frontend
├── secrets/
│   ├── registry-secret.yaml        # Docker registry credentials (both namespaces)
│   └── db-secret.yaml              # Database password (backend namespace)
├── storage/
│   ├── storageclass-rancher.yaml   # Rancher local-path provisioner
│   └── pvc-claim.yaml              # Persistent volume claim
├── rbac/
│   ├── serviceaccount.yaml         # Service accounts (both namespaces)
│   ├── role.yaml                   # Roles (both namespaces)
│   └── rolebinding.yaml            # Role bindings (both namespaces)
├── deployments/
│   ├── backend-deployment.yaml     # Backend (3 replicas, digilians-backend)
│   └── frontend-deployment.yaml    # Frontend (3 replicas, digilians-frontend)
├── services/
│   ├── backend-service.yaml        # Backend service (ClusterIP)
│   └── frontend-service.yaml       # Frontend service (ClusterIP)
├── statefulsets/
│   └── db-statefulset.yaml         # PostgreSQL StatefulSet (1 replica, with PVC)
├── apply-all.sh                    # Script to apply all manifests
└── README.md                       # This file
```

## Concepts Used

- **Namespaces**: Separated backend and frontend into different namespaces for isolation
- **Deployments**: Both backend and frontend use Deployment with 3 replicas for high availability
- **Services**: ClusterIP services for internal communication
- **StatefulSet**: PostgreSQL database with persistent storage
- **Secrets**: Registry credentials and database passwords
- **RBAC**: ServiceAccount, Role, and RoleBinding for pod permissions
- **StorageClass**: Rancher local-path provisioner for persistent volumes
- **PersistentVolumeClaim**: Storage for database

## Cleanup

To remove all resources:
```bash
kubectl delete namespace digilians-backend digilians-frontend
```

## Notes
- Update image URIs in deployments with your private registry path
- Change the database password in `secrets/db-secret.yaml` before production use
- Adjust resource requests/limits in deployments as needed
- The StorageClass provisioner is set to `rancher.io/local-path`; adjust if using a different provisioner
