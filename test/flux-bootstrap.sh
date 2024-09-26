#!/usr/bin/env bash

GITHUB_OWNER=pinax-network
GITHUB_REPOSITORY=kamaji-cluster-mesh
GITHUB_BRANCH=main

# Export the GitHub token for flux bootstrap
GITHUB_TOKEN=$(sops -d ./test/github_token)
export GITHUB_TOKEN

# Bootstrapping the staging cluster using a GitHub PAT
flux bootstrap github \
    --registry=ghcr.io/fluxcd \
    --owner=$GITHUB_OWNER \
    --repository=$GITHUB_REPOSITORY \
    --branch=$GITHUB_BRANCH \
    --token-auth \
    --private=false \
    --path=clusters/management
