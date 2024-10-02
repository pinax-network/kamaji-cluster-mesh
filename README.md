# kamaji-cluster-mesh

This repository demonstrates how to use Cluster API with Kamaji and KubeVirt
providers, deploying tenant clusters with Cilium CNI for meshing. The project
focuses on setting up multi-tenant Kubernetes clusters with integrated networking,
enabling seamless communication between clusters.

## Features

- **Cluster API**: Automate cluster lifecycle management.
- **Kamaji**: Centralized Kubernetes control plane management.
- **KubeVirt**: Virtual machine management within Kubernetes.
- **Cilium CNI**: Advanced networking and security with cluster mesh support.
- **Kind/Tilt**: Automated dev environment setup with a web UI.

## Requirements

This project uses Nix Flakes to manage and install the necessary dependencies for
setting up and managing the cluster mesh. The `flake.nix` file contains all the
required configurations and package dependencies, making the environment setup
reproducible and straightforward.

Installing Nix with flakes support is beyond the scope of this repo, however I recommend
using the full featured `nix-installer` at <https://github.com/DeterminateSystems/nix-installer>.

Alternatively, you can manually install every separate dependencies mentioned
in the `flake.nix` file, but we can't guarantee it working since package versions
will most likely not match the one used in the Nix environment.

## Getting Started

### 1. Clone the repository

```bash
git clone https://github.com/pinax-network/kamaji-cluster-mesh.git
cd kamaji-cluster-mesh
```

### 2. Enter the Nix development environment

```bash
nix develop
```

### 3. Setup the environment variables for bootstrap

Since this demo uses fluxCD to bootstrap the management cluster, you will
need to configure some environment variables before bootstrapping.

To bootstrap Flux, the person running the command must have cluster admin
rights for the target Kubernetes cluster. It is also required that the
person running the command to be the owner of the GitHub repository, or
to have admin rights of a GitHub organization.

If you don't have the required access permission to this repo, you will have to
change the [flux bootstrap script](scripts/flux-bootstrap.sh) to use your
own GitHub Repo instead.

For accessing the GitHub API, the bootstrap command requires a GitHub personal
access token (PAT) with administration permissions.

The GitHub PAT can be exported as an environment variable:

```bash
export GITHUB_TOKEN=<gh-token>
```

Alternatively, you can use `sops` to encrypt a GitHub PAT token
in this repo and point the [flux bootstrap script](scripts/flux-bootstrap.sh)
to it. If the `GITHUB_TOKEN` variable is not set, the bootstrap script
will try to decrypt the secret using sops automatically.

### 4. Bootstrap the management cluster

This repository contains a [Tiltfile](https://tilt.dev/) that is used for local
development. To build a local k8s cluster with kind run:

```bash
make setup
```

To bring up a tilt development environment run `tilt up` or:

```bash
make up
```

Once the management cluster is up and ready, you can create workloads clusters
with `kamaji` and the `kubevirt` by leveraging the `cluster-api-operator`. Workload
clusters are located in the `tenant-clusters` directory.

To bootstrap the quickstart-cluster on the management cluster run:

```bash
kubectl apply -k ./tenant-clusters
```

Once the tenant cluster is deployed, you can obtain its kubeconfig with this command:

```bash
kubectl -n tenant-system get secrets tenant-0-kubevirt-admin-kubeconfig -o json \
      | jq -r '.data["admin.conf"]' \
      | base64 --decode \
      > tenant-0.kubeconfig
```

You can then use the following `kubeconfig` to interact with the tenant-cluster.

```bash
kubectl --kubeconfig=tenant-0.kubeconfig -n kube-system get pods
```
