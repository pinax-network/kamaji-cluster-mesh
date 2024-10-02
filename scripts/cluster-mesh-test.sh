#!/usr/bin/env bash

set -o errexit

export KUBECONFIG=tenants.kubeconfig
export CLUSTER1=kubernetes-admin-tenant-1@tenant-1-kubevirt
export CLUSTER2=kubernetes-admin-tenant-2@tenant-2-kubevirt

cilium status --wait --context $CLUSTER1
cilium status --wait --context $CLUSTER2

cilium clustermesh connect \
    --context $CLUSTER1 \
    --destination-context $CLUSTER2

cilium clustermesh status --context $CLUSTER1 --wait

echo "=================================================="
echo "Deploying the cilium demo cluster-mesh application"
echo "=================================================="

kubectl --context $CLUSTER1 \
    apply -f https://raw.githubusercontent.com/cilium/cilium/1.16.2/examples/kubernetes/clustermesh/global-service-example/cluster1.yaml

kubectl --context $CLUSTER2 \
    apply -f https://raw.githubusercontent.com/cilium/cilium/1.16.2/examples/kubernetes/clustermesh/global-service-example/cluster2.yaml

echo "=============================================================="
echo "Testing the cluster-mesh by accessing the service in cluster-1"
echo "=============================================================="

for _ in {1..20}; do
    kubectl --context $CLUSTER1 \
        exec -ti deployment/x-wing -- curl rebel-base
done
