#!/usr/bin/env bash

set -o errexit

KIND_CLUSTER_NAME="${KIND_CLUSTER_NAME:-kind}"

echo "> Deleting Management cluster..."
kind delete cluster --name="$KIND_CLUSTER_NAME"
