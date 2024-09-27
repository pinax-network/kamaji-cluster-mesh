load('ext://helm_remote', 'helm_remote')

# Cilium CNI
helm_remote(
    'cilium',
    version="1.16.1",
    namespace="kube-system",
    repo_name='cilium',
    values=['./test/cilium/helm-values.yaml'],
    repo_url='https://helm.cilium.io'
)

# Create a local resource that waits for Cilium's deployment to be complete
local_resource(
    'cilium_wait',
    cmd='echo "Waiting for Cilium..."',
    resource_deps=['cilium'],
    deps=['./test/cilium/helm-values.yaml']
)

local_resource(
    'lb_crds',
    cmd='kubectl apply -f ./test/cilium/crd-values.yaml',
    resource_deps=['cilium_wait'],
    deps=['./test/cilium/crd-values.yaml']
)

local_resource(
    'flux',
    cmd='./test/flux-bootstrap.sh',
    resource_deps=['lb_crds'],
    deps=['./test/flux-bootstrap.sh'],
    env={'GITHUB_TOKEN': os.getenv('GITHUB_TOKEN', '')}
)
