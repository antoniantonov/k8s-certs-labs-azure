# Troubleshooting etcd

## Backup
Find out what certs to use for etcdctl
```bash
cat /etc/kubernetes/manifests/etcd.yaml
```

```yaml
...
spec:
  containers:
  - command:
    - etcd
    - --advertise-client-urls=https://192.168.100.31:2379
    - --cert-file=/etc/kubernetes/pki/etcd/server.crt                           # use
...
    - --initial-cluster=cluster3-controlplane1=https://192.168.100.31:2380
    - --key-file=/etc/kubernetes/pki/etcd/server.key                            # use
    - --listen-client-urls=https://127.0.0.1:2379,https://192.168.100.31:2379   # use
...
    - --peer-trusted-ca-file=/etc/kubernetes/pki/etcd/ca.crt                    # use
```

Check API server config to ensure is connected properly to etcd
```bash
cat /etc/kubernetes/manifests/kube-apiserver.yaml | grep etcd
```
```
    - --etcd-cafile=/etc/kubernetes/pki/etcd/ca.crt
    - --etcd-certfile=/etc/kubernetes/pki/apiserver-etcd-client.crt
    - --etcd-keyfile=/etc/kubernetes/pki/apiserver-etcd-client.key
    - --etcd-servers=https://127.0.0.1:2379
```

Backup command
```bash
ETCDCTL_API=3 etcdctl snapshot save /tmp/etcd-backup.db \
--cacert /etc/kubernetes/pki/etcd/ca.crt \
--cert /etc/kubernetes/pki/etcd/server.crt \
--key /etc/kubernetes/pki/etcd/server.key
```

Check the backup status (IMPORTANT: This can alter the backup file)
```bash
ETCDCTL_API=3 etcdctl snapshot status /etc/etcd-snapshot.db
```

## Restore
Prior performing restore operation, is good idea to stop all k8s components
```bash
cd /etc/kubernetes/manifests/
# Move all the manifests a folder up.
mv * ..
watch crictl ps

# After restore move them back
cd /etc/kubernetes/manifests/
mv ../*.yaml .
watch crictl ps
```

Same certs as backup
```bash
ETCDCTL_API=3 etcdctl snapshot restore /tmp/etcd-backup.db \
--data-dir /var/lib/etcd-backup \               # This is the new data dir for the etcd DB
--cacert /etc/kubernetes/pki/etcd/ca.crt \
--cert /etc/kubernetes/pki/etcd/server.crt \
--key /etc/kubernetes/pki/etcd/server.key
```

Update the etcd manifest to use the new data dir
```bash
vim /etc/kubernetes/etcd.yaml
```
```yaml
...
  volumes:
  - hostPath:
      path: /etc/kubernetes/pki/etcd
      type: DirectoryOrCreate
    name: etcd-certs
  - hostPath:
      path: /var/lib/etcd-backup                # <-- Change
      type: DirectoryOrCreate
    name: etcd-data
status: {}
```