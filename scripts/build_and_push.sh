#!/usr/bin/env bash
set -euo pipefail

# Build and push Digilians backend and frontend images to Docker Hub
# Usage: ./scripts/build_and_push.sh [version]
# If version is provided, tags will be digilians:backend-<version> and digilians:frontend-<version>

REPO="mesterjoe/digilians"
VERSION=${1:-latest}

if [ "$VERSION" = "latest" ]; then
  BACKEND_TAG="$REPO:backend"
  FRONTEND_TAG="$REPO:frontend"
else
  BACKEND_TAG="$REPO:backend-$VERSION"
  FRONTEND_TAG="$REPO:frontend-$VERSION"
fi

echo "Building backend -> $BACKEND_TAG"
docker build -t "$BACKEND_TAG" ./backend

echo "Building frontend -> $FRONTEND_TAG"
docker build -t "$FRONTEND_TAG" ./frontend

echo "Pushing images (make sure you ran 'docker login' first)"
docker push "$BACKEND_TAG"
docker push "$FRONTEND_TAG"

echo "All done."
