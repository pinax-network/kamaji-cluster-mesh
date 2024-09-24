#!/usr/bin/env bash

set -e

# ===================================
KIND_CLUSTER_NAME="${KIND_CLUSTER_NAME:-management}"

# Flux ENV config
GITHUB_OWNER=pinax-network
GITHUB_REPOSITORY=kamaji-cluster-mesh
GITHUB_BRANCH=main

# Export the GitHub token for flux bootstrap
GITHUB_TOKEN=$(sops -d ./setup/github_token)
export GITHUB_TOKEN
# ===================================

# Bootstrapping the staging cluster using a GitHub PAT
flux bootstrap github \
    --registry=ghcr.io/fluxcd \
    --components-extra=image-reflector-controller,image-automation-controller \
    --owner=$GITHUB_OWNER \
    --repository=$GITHUB_REPOSITORY \
    --branch=$GITHUB_BRANCH \
    --token-auth \
    --private=false \
    --path=clusters/"$KIND_CLUSTER_NAME"
