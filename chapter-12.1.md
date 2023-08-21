# Scheduling labs

### Remove or add a taint from and to master node
```bash
# Remove NoSchedule taint from a master node
kubectl taint nodes k8s-cp node-role.kubernetes.io/control-plane-

# Remove all taints from all master node
kubectl taint nodes --all node-role.kubernetes.io/control-plane-

# Add NoSchedule taint to a master node
kubectl taint nodes k8s-cp node-role.kubernetes.io/control-plane=:NoSchedule
```

## How to view how many containers are running on a node with containerd
```bash
# From root account or with sudo
sudo crictl ps -a | grep -c running

# Also directly through containerd CLI
sudo ctr c list | grep -c running
```