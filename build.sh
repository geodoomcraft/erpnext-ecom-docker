#!/bin/bash
set -e

FRAPPE_VERSION=${FRAPPE_VERSION:-"0.0.0"}
ERPNEXT_VERSION=${ERPNEXT_VERSION:-"0.0.0"}
ECOMM_VERSION=${ECOMM_VERSION:-"0.0.0"}

TAG="v15-frappe-${FRAPPE_VERSION}-erpnext-${ERPNEXT_VERSION}-ecom-${ECOMM_VERSION}"

echo "📦 Building Docker image with tag: ${TAG}"

# Clone frappe_docker
rm -rf frappe_docker
git clone https://github.com/frappe/frappe_docker
cd frappe_docker

# Set apps.json parameter
APPS_JSON_BASE64=$(base64 -w 0 ~/apps.json)

cd ~/frappe_docker/
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
