# What is it
ETCD is the key-value store that stores the state of the Kubernetes cluster.

# Enable ETCD encryption

Create a key and EncryptionConfiguration
```bash
mkdir -p /etc/kubernetes/etcd
echo -n this-is-very-sec | base64  # dGhpcy1pcy12ZXJ5LXNlYw==
```

```yaml
apiVersion: apiserver.config.k8s.io/v1
kind: EncryptionConfiguration
resources:
  - resources:
    - secrets
    providers:
    - aesgcm:
        keys:
        - name: key1
          secret: dGhpcy1pcy12ZXJ5LXNlYw==
    - identity: {}
```

Update apiserver manifest to specify encryption configuration and mount directory, so api can access it.
```yaml
...
- --encryption-provider-config=/etc/kubernetes/etcd/ec.yaml
...
    volumeMounts:
    - mountPath: /etc/kubernetes/etcd
      name: etcd
      readOnly: true
...
    hostNetwork: true
    priorityClassName: system-cluster-critical
    volumes:
    - hostPath:
        path: /etc/kubernetes/etcd
        type: DirectoryOrCreate
        name: etcd
```

In order to encrypt the secrets in the cluster, need to delete and recreate all of them
```bash
kubectl get secrets --all-namespaces -o json | kubectl replace -f -

# For namespace 'one' secrets
kubectl -n one get secrets -o json | kubectl replace -f -
```

To check if the secret c1 under secrets namespace is encrypted at rest run the following:
```bash
ETCDCTL_API=3 etcdctl --cert /etc/kubernetes/pki/apiserver-etcd-client.crt --key /etc/kubernetes/pki/apiserver-etcd-client.key --cacert /etc/kubernetes/pki/etcd/ca.crt get /registry/secrets/one/s1
```