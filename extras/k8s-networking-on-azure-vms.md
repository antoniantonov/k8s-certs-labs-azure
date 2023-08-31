# How to configure K8s networking and networking policy when on vanilla K8s on Azure VMs

## Some problems descriptions here
1. Calico on K8s with Azure VMs and default setup doesn't work
https://docs.tigera.io/archive/v3.9/reference/public-cloud/azure

- Solution?
https://stackoverflow.com/questions/60222243/calico-k8s-on-azure-cant-access-pods

## Install networking plugins
1. Install flannel. 
- Make sure during kubeadm setup, you use the following option config that matches the Flannel default CIDR:
``` yaml
apiVersion: kubeadm.k8s.io/v1beta3
kind: ClusterConfiguration
kubernetesVersion: 1.27.1
controlPlaneEndpoint: "k8scp:6443"
networking:
  podSubnet: 10.244.0.0/16
```
- Install flannel from here: https://github.com/flannel-io/flannel#deploying-flannel-manually 

## Install policy plugins
1. Use Calico for policy only
https://docs.tigera.io/archive/v3.9/getting-started/kubernetes/installation/other
- Check controller manager flags
``` bash
kubectl -n kube-system describe pod kube-controller-manager-k8s-cp
```
