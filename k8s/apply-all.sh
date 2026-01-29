#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR=$(dirname "$0")

kubectl apply -f "$ROOT_DIR/namespaces/dev-namespace.yaml"
# Note: registry-secret.yaml is created via kubectl commands, not applied here
kubectl apply -f "$ROOT_DIR/secrets/db-secret.yaml"
kubectl apply -f "$ROOT_DIR/storage/storageclass-rancher.yaml"
kubectl apply -f "$ROOT_DIR/rbac/serviceaccount.yaml"
kubectl apply -f "$ROOT_DIR/rbac/role.yaml"
kubectl apply -f "$ROOT_DIR/rbac/rolebinding.yaml"

kubectl apply -f "$ROOT_DIR/deployments/backend-deployment.yaml"
kubectl apply -f "$ROOT_DIR/deployments/frontend-deployment.yaml"

kubectl apply -f "$ROOT_DIR/services/backend-service.yaml"
kubectl apply -f "$ROOT_DIR/services/frontend-service.yaml"

kubectl apply -f "$ROOT_DIR/statefulsets/db-statefulset.yaml"

echo "All manifests applied successfully!"
echo "Backend namespace: digilians-backend"
echo "Frontend namespace: digilians-frontend"
