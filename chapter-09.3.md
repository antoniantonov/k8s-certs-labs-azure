# Working with CoreDNS

## How to setup a nettool pod
1. Create the following yaml file:
``` yaml
apiVersion: v1
kind: Pod
metadata:
  name: ubuntu
spec:
  containers:
  - name: ubuntu
    image: ubuntu:latest
    command: [ "sleep" ]
    args: [ "infinity" ]
  nodeSelector:
    system: firstOne
```

2. Deploy the yaml file and exec to it.
``` bash
kubectl create -f ubuntu.yaml
kubectl exec -it ubuntu -- /bin/bash
```

4. Install net-tools
``` bash
root@ubuntu:/
    apt-get update ; apt-get install curl dnsutils -y
    apt install iputils-ping
```