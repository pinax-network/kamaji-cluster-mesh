#!/usr/bin/env bash

set -o errexit

KIND_CLUSTER_NAME="${KIND_CLUSTER_NAME:-management}"

cat <<EOF | kind create cluster --name "${KIND_CLUSTER_NAME}" --config=-
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
- role: control-plane
  extraPortMappings:
  - containerPort: 32000
    hostPort: 32000
networking:
  disableDefaultCNI: true
  kubeProxyMode: "none"
EOF

cilium install --set cluster.name="$KIND_CLUSTER_NAME" --set cluster.id=1 --context kind-"$KIND_CLUSTER_NAME"
cilium clustermesh enable --context kind-"$KIND_CLUSTER_NAME" --service-type NodePort
cilium status --wait
