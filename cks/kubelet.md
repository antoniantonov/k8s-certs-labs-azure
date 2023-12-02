# What is it?
Kubelet is the primary "node agent" that runs on each node. It can register the node with the apiserver using one of: the hostname; a flag to override the hostname; or specific logic for a cloud provider.

# How to find out where is the kubelet config file
```bash
ps -ef | grep kubelet

#root      5157     1  2 20:28 ?        00:03:22 /usr/bin/kubelet --bootstrap-kubeconfig=/etc/kubernetes/bootstrap-kubelet.conf
#--kubeconfig=/etc/kubernetes/kubelet.conf --config=/var/lib/kubelet/config.yaml --network-plugin=cni 
#--pod-infra-container-image=k8s.gcr.io/pause:3.2
#root     19940 11901  0 22:38 pts/0    00:00:00 grep --color=auto kubelet

vim /var/lib/kubelet/config.yaml
```

# Contact API server as kubelet from terminal
```bash
export KUBECONFIG=/etc/kubernetes/kubelet.conf
kubectl get nodes
```