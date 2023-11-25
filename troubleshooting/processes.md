# Troubleshooting processes related to Kubernetes

## Kubelet 

Look for the running process
```bash
ps aux | grep kubelet # shows kubelet process
journalctl -u kubelet # shows kubelet logs
```

Check the status of the process
```bash
systemctl status kubelet
service kubelet status

# Start/restart 
```bash
service kubelet start
service kubelet restart
```

What components are controller by systemd
```bash
find /etc/systemd/system/ | grep kubelet
find /etc/systemd/system/ | grep etcd
```

Check kubelet manifest path in the systemd file for parameter --pod-manifest-path
```bash
find /etc/systemd/system/ | grep kube
cat /etc/systemd/system/kubelet.service.d/10-kubeadm.conf
```