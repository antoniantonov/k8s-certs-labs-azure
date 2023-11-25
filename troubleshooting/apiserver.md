# Troubleshooting API server not starting/working

## Logs locations to check when API server is not starting
``` bash
# Inside linux terminal check the following locations
ls -la /var/log/pods
ls -la /var/log/containers

# Get logs from the container runtime
crictl ps
crictl logs f669a6f3afda2
watch crictl ps # Watch the logs for changes in real time.

# If docker is used
docker ps
docker logs f669a6f3afda2

# Check kubelet logs
cat /var/log/syslog | grep apiserver
tail -f /var/log/syslog | grep apiserver
journalctl | grep apiserver
```

## The API server manifest location
```bash
vim /etc/kubernetes/manifests/kube-apiserver.yaml

# Making a backup
cp /etc/kubernetes/manifests/kube-apiserver.yaml ~/kube-apiserver.yaml.ori
```

## Check API server pod's logs
```bash
cat /var/log/pods/kube-system_kube-apiserver-controlplane_a3a455d471f833137588e71658e739da/kube-apiserver/X.log
```

## Restart the kublet service 
```bash
# After modifications to the API server manifest, it may be necessary to restart the kubelet service.
service kubelet restart
```

## Curl the API server manually
```bash