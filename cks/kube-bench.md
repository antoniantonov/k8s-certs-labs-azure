# What is kube-bench
kube-bench is a Go application that checks whether Kubernetes is deployed securely by running the checks documented in the CIS Kubernetes Benchmark.

# Installation

# Running kube-bench
Need to SSH to the node where we want to run the tests.
```bash
kube-bench run --targets=master
kube-bench run --targets=master | grep kube-controller -A 3 # -A - after the hit
kube-bench run --targets=master | grep "/var/lib/etcd" -B 5 # -B - before the hit

# SSH to worker nodes and check kubelet config for permissions for e.g.
kube-bench run --targets=node | grep /var/lib/kubelet/config.yaml -B2

# Run specific checks for master and node
kube-bench run --targets master --check 1.2.20
kube-bench run --targets node --check 1.2.20
```