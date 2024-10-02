#!/usr/bin/env bash

set -o errexit

CLUSTER1=$(mktemp)
CLUSTER2=$(mktemp)

# Get the tenant-1 kubeconfig
kubectl -n tenant-system get secrets tenant-1-kubevirt-admin-kubeconfig -o json |
    jq -r '.data["admin.conf"]' |
    base64 --decode |
    sed -e 's/kubernetes-admin/kubernetes-admin-tenant-1/g' \
        >"$CLUSTER1"

# Get the tenant-2 kubeconfig
kubectl -n tenant-system get secrets tenant-2-kubevirt-admin-kubeconfig -o json |
    jq -r '.data["admin.conf"]' |
    base64 --decode |
    sed -e 's/kubernetes-admin/kubernetes-admin-tenant-2/g' \
        >"$CLUSTER2"

KUBECONFIG=$CLUSTER1:$CLUSTER2 kubectl config view --merge --flatten >tenants.kubeconfig

rm "$CLUSTER1" "$CLUSTER2"
