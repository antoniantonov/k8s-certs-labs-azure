# Troubleshooting or setting up nodes

## Add new node to the cluster
Use kubeadm on the control plane node to generate a token and join command. Then run the join command on the new node.
```bash
kubeadm token create --print-join-command
kubeadm token list
```

On the new node run the join command
```bash
kubeadm join k8scp:6443 --token dhdsu2.wm96... --discovery-token-ca-cert-hash sha256:d4585c330d78...
```

## Upgrade node
If node is joined to the cluster use the following command:
```bash
kubeadm upgrade node
```


```bash
# Check the versions
kubeadm version
kubectl version --short
kubelet --version
```

Upgrade the rest of the components
```bash
apt install kubectl=1.27.1-00 kubelet=1.27.1-00
service kubelet restart
```

## Check the status of the node
```bash
kubectl get nodes
kubectl get nodes -o wide
```

If the status is not ready
- Check the kubelet service (./troubleshooting/processes.md)