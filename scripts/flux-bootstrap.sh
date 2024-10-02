#!/usr/bin/env bash

set -o errexit

GITHUB_OWNER=pinax-network
GITHUB_REPOSITORY=kamaji-cluster-mesh
GITHUB_BRANCH=main

# Check if GITHUB_TOKEN is already set; if not, use sops to decrypt it
if [ -z "$GITHUB_TOKEN" ]; then
    GITHUB_TOKEN=$(sops -d ./secrets/github_token)
    export GITHUB_TOKEN
fi

# Bootstrapping the staging cluster using a GitHub PAT
flux bootstrap github \
    --registry=ghcr.io/fluxcd \
    --owner=$GITHUB_OWNER \
    --repository=$GITHUB_REPOSITORY \
    --branch=$GITHUB_BRANCH \
    --token-auth \
    --private=false \
    --path=clusters/management
