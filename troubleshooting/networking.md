# Troubleshooting Networking in Kubernetes

## No connectivity b/n pods in different nodes
Try to ping the pod's IP address from the other node. If it works, then the problem is with DNS resolution. If it doesn't work, then the problem is with the network.

- These settings might be ephemeral and will be lost after reboot.
``` bash
swapoff -a
modprobe overlay
modprobe br_netfilter
```