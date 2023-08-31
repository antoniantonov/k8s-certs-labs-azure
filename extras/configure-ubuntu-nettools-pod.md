# How to setup a nettool pod

## Setup
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

## Testing 
1. DNS resolution for services. Services by default have A/AAAA 
``` bash
root@ubuntu:/
    nslookup postgres-service.production.svc.cluster.local
    nslookup kubernetes.default.svc
    nslookup kubernetes.default.svc.cluster.local
```
``` bash
anton@k8s-cp:~$ kubectl get svc 
NAME                               TYPE           CLUSTER-IP       EXTERNAL-IP   PORT(S)         AGE
break2-nodeport                    NodePort       10.105.245.12    <none>        80:31074/TCP    8d
foodie3-loadbalancer               LoadBalancer   10.110.225.202   <pending>     80:30665/TCP    2d21h
kubernetes                         ClusterIP      10.96.0.1        <none>        443/TCP         14d
mydashboard-kubernetes-dashboard   NodePort       10.97.16.109     <none>        443:32171/TCP   12d
anton@k8s-cp:~$ kubectl exec -it ubuntu -- bin/bash
root@ubuntu:/# nslookup foodie3-loadbalancer
Server:         10.96.0.10
Address:        10.96.0.10#53

Name:   foodie3-loadbalancer.default.svc.cluster.local
Address: 10.110.225.202

root@ubuntu:/# 
```

2. DNS resolution for pods. Pods by default don't have A/AAAA records. You need to expose a service for the pod to use DNS resolution.
``` bash
kubectl get pods -o wide
kubectl exec -it ubuntu -- bin/bash

# Note the replacement of '-' instead of '.' in the IP when using the pod FQDN. 
root@ubuntu:/# nslookup 10-244-2-41.default.pod.cluster.local
```