#!/bin/bash
set -e
set -x  # enable debug output

FRAPPE_VERSION=${FRAPPE_VERSION:-"0.0.0"}
ERPNEXT_VERSION=${ERPNEXT_VERSION:-"0.0.0"}
ECOMM_VERSION=${ECOMM_VERSION:-"0.0.0"}

TAG="v15-frappe-${FRAPPE_VERSION}-erpnext-${ERPNEXT_VERSION}-ecom-${ECOMM_VERSION}"

echo "📦 Building Docker image with tag: ${TAG}"
echo "Current directory: $(pwd)"
ls -la

# Remove old clone if exists
rm -rf frappe_docker

# Clone frappe_docker into current directory
git clone https://github.com/frappe/frappe_docker

echo "After cloning frappe_docker:"
ls -la

# Confirm apps.json exists at repo root (where this script runs)
if [ ! -f ./apps.json ]; then
  echo "❌ Error: apps.json not found in $(pwd)"
  exit 1
fi

APPS_JSON_BASE64=$(base64 -w 0 ./apps.json)

cd frappe_docker

echo "Inside frappe_docker directory: $(pwd)"
ls -la

# Build and push docker image
docker buildx build \
  --push \
  --platform=linux/amd64,linux/arm64 \
  --build-arg=FRAPPE_PATH=https://github.com/frappe/frappe \
  --build-arg=FRAPPE_BRANCH=version-15 \
  --build-arg=APPS_JSON_BASE64=${APPS_JSON_BASE64} \
  --tag=docker.io/geodoomcraft/erpnext-ecom:latest \
  --tag=docker.io/geodoomcraft/erpnext-ecom:${TAG} \
  --file=images/layered/Containerfile .

echo "✅ Image pushed: geodoomcraft/erpnext-ecom:${TAG}"

