#!/usr/bin/env bash

set -o errexit

# desired cluster name; default is "kind"
KIND_CLUSTER_NAME="${KIND_CLUSTER_NAME:-management}"

echo "> Deleting Management cluster..."
kind delete cluster --name="$KIND_CLUSTER_NAME"
