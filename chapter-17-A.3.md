# Exercises from Chapter 17 - A.3

## 1. 
The yaml file has the wrong image name. Should be:
``` yaml
image: nginx:1.25-alpine
```

## 2. 
No answer needed.

## 3.
Fixed file [review2.yaml](./files/review2.yaml).
Also added this file [review2-service.yaml](./files/review2-service.yaml) to make the service accessible from outside the cluster.
``` bash
# Deploy the deployment and the NodePort service to expose the pod.
kubectl create -f review2.yaml
kubectl create -f review2-service.yaml

# Get the port number of the service.
kubectl get svc break2-nodeport -o yaml | grep nodePort

# Find out the IP address of any node in the cluster and use it in the browser or do curl from anywhere.
curl ifconfig.io

# Access the service from the browser or curl.
curl <IP address>:<nodePort>
```

## 4.
``` bash
kubectl logs break2-664846b9bc-qdvfs 
```

## 5.
No answer needed.

## 6.
Use the [review4.yaml](./files/review4.yaml). Note the following:
``` yaml
  nodeSelector:
    system: secondOne
```
Create label on the worker node. Then re-create the pod again and make sure it is running on the second node.
``` bash
kubectl label nodes k8s-worker system=secondOne
kubectl create -f review4.yaml
kubectl get pods -A -o wide
```

## 7.
Requirements for the container: 1 CPU core and 1036MB of memory.

## 8.
Make the following changes to the [review4.yaml](./files/review4.yaml) file:
``` yaml
spec:
  containers:
  - image: vish/stress
    name: design-pod1
    resources:
      limits:
        cpu: "2.0"      # <-- This change here
        memory: "600Mi"
      requests:
        cpu: "0.3"
        memory: "100Mi"
```

## 9.
Use the [review4.yaml](./files/review4.yaml) file. Then check to see if the pod `design-pod1` running, specifically on the worker node. 
``` bash
kubectl create -f review4.yaml
kubectl get pods -A -o wide

# Check to see how much is consuming. To use 'top' you need to configure metric-server.
kubectl top pods
```

How to configure metric-server for Kubernetes please follow this [example](./extras/configure-metric-server.md).

## 10.
```bash
kubectl  create -f review5.yaml
kubectl get pods
```

## 11.
```bash
kubectl get pods --show-labels
kubectl get pods -l review=tux
kubectl delete pods -l review=tux
```

## 12.
Use the following [cronjob1.yaml](./files/cronjob1.yaml) file.
```bash
kubectl create -f cronjob.yaml
kubectl get cronjobs

# Wait for 3 minutes and then run the following command.
kubectl get pods
kubectl logs cron-mf-job-28214796-sm9nq 

# After few minutes delete the cronjob
kubectl delete cronjobs.batch cron-mf-job
```
For the rest of the exercise use the [cronjob2.yaml](./files/cronjob2.yaml) file. 

## 13.
```bash
kubectl delete cronjobs.batch cron-mf-job
kubectl delete cronjobs.batch cron-mf-job-mondays
```

## 14.
Use the [secret1.yaml](./files/secret1.yaml) file. Keep in mind that for Opaque secrets the base64 encoding does not happen automatically. Then run the following commands:
```bash
kubectl create -f secret1.yaml
kubectl get secrets
kubectl get secret specialoftheday -o jsonpath="{.data.entree}" | base64 --decode
```

## 15.
Use the [foodie.yaml)(./files/foodie.yaml) file. Then run the following commands:
```bash
kubectl create -f foodie.yaml
```

## 16.
Use the [foodie.yaml](./files/foodie.yaml) file. It has the secret mounted as a volume.

## 17.
```bash
kubectl exec -it foodie -- /bin/bash
root@foodie-79c5554b97-dlvvw:/ cat food/entree
```

## 18.
Need to patch the deployment manifest to include the rolling update strategy. 
```yaml
  progressDeadlineSeconds: 600
  replicas: 1
  revisionHistoryLimit: 10
  strategy:
    type: Recreate
```
And then update the image directly of the deployed container:
```bash
kubectl set image deploy foodie nginx=nginx:1.23.1-alpine
kubectl get pod foodie-55cb84c84-cw2h4 -o yaml | grep image

# Check the revision history
kubectl rollout history deployment foodie
```

## 19.
Rollback to revision 1:
```bash
kubectl rollout undo deployment foodie --to-revision=1
kubectl get pod foodie-79c5554b97-22fhv -o yaml | grep image

# Should have now revision 2 and 3 only.
kubectl rollout history deployment foodie
```

## 20.
To install and configure NFS persistent volume refer to [configure-nfs-volume.md](./extras/configure-nfs-volume.md). Then use the [nfs-pv.yaml](./files/nfs-pv.yaml) file to create the persistent volume.
```bash
kubectl create -f nfs-pv.yaml
kubectl get pv
```

## 21.
Use the [nfs-pvc.yaml](./files/nfs-pvc.yaml) file to create the persistent volume claim.
```bash
kubectl create -f nfs-pvc.yaml
kubectl get pvc

# This should bound the PVC to the PV
# anton@k8s-cp:~$ kubectl get pvc
# NAME        STATUS   VOLUME      CAPACITY   ACCESS MODES   STORAGECLASS   AGE
# reviewpvc   Bound    reviewvol   200Mi      RWX                           8h
# anton@k8s-cp:~$ kubectl get pv
# NAME        CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS   CLAIM               STORAGECLASS   REASON   AGE
# reviewvol   200Mi      RWX            Recycle          Bound    default/reviewpvc                           8h
# anton@k8s-cp:~$
```

## 22.
Use the following [foodie2.yaml](./files/foodie2.yaml) file. It has the persistent volume claim mounted as a volume.
```bash
kubectl create -f foodie2.yaml

# "-o wide" to ensure you have it running on worker node. Better test to show shared NFS volume.
kubectl get pods -o wide
# foodie2-7c87b7b897-d2ss4  1/1  Running  0  5m1s  10.244.2.36  k8s-worker
```

## 23.
```bash
kubectl exec -it foodie2-7f9f9f7f5f-8q9q5 -- /bin/bash

root@foodie2-7f9f9f7f5f-8q9q5:/# df -h
# Result:
# ...
# k8scp:/opt/sfw   29G  6.6G   23G  23% /newvol
# ...
root@foodie2-7f9f9f7f5f-8q9q5:/# ls -la /newvol/
# Result: If you have followed the previous steps to setup NFS volume, you should see the following:
# drwxrwxrwt 2 root root 4096 Aug 27 06:52 .
# drwxr-xr-x 1 root root 4096 Aug 27 18:49 ..
# -rw-r--r-- 1 root root    9 Aug 27 06:52 hello.txt     # <-- This is the file created on the CP node.
```

## 24.
```bash
kubectl delete -f foodie2.yaml
kubectl delete -f nfs-pvc.yaml
kubectl delete -f nfs-pv.yaml
```
## 25.
Use the [foodie3.yaml](./files/foodie3.yaml) file. 
```bash
kubectl create -f foodie3.yaml
kubectl get pods -o wide
```

## 26.
Use the [foodie3-loadbalancer.yaml](./files/foodie3-loadbalancer.yaml) file to deploy the load balancer service.
Refer to [configure-ubuntu-nettools-pod.md](./extras/configure-ubuntu-nettools-pod.md) for more details on how to test exposed services.
```bash
kubectl create -f foodie3-loadbalancer.yaml
kubectl describe svc foodie3-loadbalancer | grep IP:

# Exec into the ubuntu container and run curl to the load balancer service on the IP returned from the previous command.
kubectl exec -it ubuntu -- /bin/bash
root@ubuntu:/# curl 10.110.225.202
```

## 27.
TBD
## 28.
TBD 
## 29.
TBD

## 30.
Use the [review6.yaml](./files/review6.yaml) file.

## 31.
```bash
kubectl get pod securityreview
kubectl logs securityreview
```
## 32.
```bash
```bash
kubectl create -f review6.yaml
kubectl get pods -o wide
kubectl logs securityreview 
```

## 33.
`Remarks: Cannot exec to non running container. So, first we need to fix it and then we can login to see the nginx UID.`
```bash
kubectl exec -it securityreview -- /bin/bash
# Get the UID of the nginx user.
root@securityreview:/ getent passwd | grep nginx

# Result - 101.
nginx:x:101:101:nginx user:/nonexistent:/bin/false
```
Check the error:
```
......
2023/08/31 13:32:44 [warn] 1#1: the "user" directive makes sense only if the master process runs with super-user privileges, ignored in /etc/nginx/nginx.conf:2
nginx: [warn] the "user" directive makes sense only if the master process runs with super-user privileges, ignored in /etc/nginx/nginx.conf:2
2023/08/31 13:32:44 [emerg] 1#1: mkdir() "/var/cache/nginx/client_temp" failed (13: Permission denied)
nginx: [emerg] mkdir() "/var/cache/nginx/client_temp" failed (13: Permission denied)
```

Two possible solutions: <br>
1. Use the unprevileged nginx image. More info [here](https://github.com/nginxinc/docker-nginx-unprivileged). Solution file is [review6-unprivileged.yaml](./files/review6-unprivileged.yaml).
```yaml
...
  - name:  webguy
    image: nginxinc/nginx-unprivileged
    ports:
    - containerPort: 8080
...
```
And then check if we can reach the default page from out nettools pod.
```bash
kubectl get pods -o wide
kubectl exec -it ubuntu -- /bin/bash

# Note the default port for unpervileged nginx is 8080.
root@ubuntu:/# curl 10.244.2.59:8080
```

2. Is the hard way - using privileged nginx image. Some of the code is taken from this [SO article](https://stackoverflow.com/questions/63108119/how-to-run-an-nginx-container-as-non-root). Other parts I figured it out by trial and error :). The solution is to build a custom docker image from privileged nginx image. The solution is here: [./files/nginx-privileged/](./files/nginx-privileged/).
```bash
# Build the docker image.
cd ./files/nginx-privileged/
docker build -t yourcontainerrepo/nginx-priviledged:latest .
docker push yourcontainerrepo/nginx-priviledged:latest

# Deploy the pod with the following manifest file
kubectl create -f ./files/nginx-privileged/review6-privileged.yaml
kubectl get pods -o wide
```

## 34.
This was covered pretty much by the previous exercise #33.

## 35.
Use the [securityaccount.yaml](./files/securityaccount.yaml) file. Then run the following commands:
```bash
kubectl create -f securityaccount.yaml
kubectl get serviceaccounts
kubectl describe serviceaccounts securityaccount
```

## 36.
Use the following file [secrole.yaml](./files/secrole.yaml) to create the role. Then run the following commands:
```bash
kubectl create -f secrole.yaml
kubectl get roles
kubectl describe roles securityrole
```

## 37.
The binding is part of the [secrole.yaml](./files/secrole.yaml) file. Creating the file in previous exercise will create the binding as well.

## 38.
There are two ways to create API token for the service account.
```bash
# This will create temporary token with expiry. 
kubectl create token securityaccount --duration=600s
```
For the purpose of this exercise we will use the second method. Create a secret with the token and then use it in the pod. Use the file 
```bash
kubectl create -f securityaccountsecret.yaml 
kubectl get secrets securityaccountsecret -o yaml

# Result
#apiVersion: v1
#data:
#  ca.crt: LS0tLS1C...
#  namespace: ZGVmYXVsdA==
#  token: ZXlKaG...          <-- This is the token.
#kind: Secret
#...
```
Create the file using vim
```bash
sudo vim /tmp/securitytoken
```

## 39.
Remove what you want from your cluster. The way I understand it, it's about the security stuff we created the last 3-4 exercises.
```bash
kubectl delete -f securityaccount.yaml
kubectl delete -f secrole.yaml
kubectl delete -f securityaccountsecret.yaml
```

## 40. 
Use the following file [webone.yaml](./files/webone.yaml) to create the deployment. Then run the following commands:
```bash
kubectl create -f webone.yaml
kubectl get pods -o wide
kubectl get svc webone-svc
```

## 41.
The file [webone.yaml](./files/webone.yaml) has the service defined as NodePort. So, we can access it from outside the cluster. To do that we need to find out the port number. Then we can use the IP address of any node in the cluster to access the service. Make sure you add the NodePort port number to the allowed list in Azure VM or the NSG (Network Security Group) to which the CP node is attached. 
```bash
# Get the port number of the service.
kubectl get svc webone-svc
# Get the CP node IP address.
curl ifconfig.io
```

## 42.
Solved with the previous exercise.

## 43.
Patch the current service to change the type to ClusterIP. This will make the service accessible only from within the cluster.
```bash
kubectl patch svc webone-svc -p '{"spec": {"type": "ClusterIP"}}'
```
Check to make sure we cannot access the service from outside the cluster (try the same address and port from the web browser as in exercise #41). 
Also, make sure we can access the nginx from the service inside the cluster.
```bash
kubectl get svc webone-svc -o yaml | grep clusterIP
kubectl exec -it ubuntu -- /bin/bash
# Use the IP obtained from the previous command.
root@ubuntu:/# curl 10.108.52.55
```

## 44.
Use the file [webtwo.yaml](./files/webtwo.yaml) to create the pod and service. Then run the following commands:
```bash
kubectl get svc webtwo-svc -o yaml | grep clusterIP
kubectl exec -it ubuntu -- /bin/bash
# Use the IP obtained from the previous command.
root@ubuntu:/# curl 10.108.52.55
```

## 45.
Try all these to make sure DNS works. Make sure you have deployed the pods to a different node than one where the ubuntu pod is deployed, in order to ensure networking is working as well. 
```bash
kubectl exec -it ubuntu -- /bin/bash
root@ubuntu:/# nslookup webone-svc
root@ubuntu:/# nslookup webone-svc.default
root@ubuntu:/# nslookup webone-svc.default.svc.local
root@ubuntu:/# nslookup webtwo-svc
root@ubuntu:/# nslookup webtwo-svc.default
root@ubuntu:/# nslookup webtwo-svc.default.svc.local
root@ubuntu:/# curl webone-svc
root@ubuntu:/# curl webone-svc.default
root@ubuntu:/# curl webone-svc.default.svc.local
root@ubuntu:/# curl webtwo-svc
root@ubuntu:/# curl webtwo-svc.default
root@ubuntu:/# curl webtwo-svc.default.svc.local
```

## 46.
Install nginx ingress controller. Refer to [configure-nginx-ingress.md](./extras/configure-nginx-ingress.md) for more details. Then use the [ingress-web-one-two.yaml](./files/ingress-web-one-two.yaml) file to create the ingress resource. Then run the following commands:
```bash
kubectl create -f ingress-web-one-two.yaml

# Get the IP of the ingress controller LoadBalancer service
kubectl get svc myingress-ingress-nginx-controller

# Check to see if both hosts work
curl -H "Host: www.webone.com" http://10.99.156.107
curl -H "Host: www.webtwo.com" http://10.99.156.107
```

## 47.
```bash
kubectl delete -f ingress-web-one-two.yaml
kubectl delete -f webone.yaml
kubectl delete -f webtwo.yaml

# Delete ingress controller from your cluster if you'd like.
helm uninstall myingress
```

## 48.
TBD

## 49.
Will be using the [noscheduler-busybox.yaml](./files/noscheduler-busybox.yaml) file. Then run the following commands:
```bash
kubectl create -f noscheduler-busybox.yaml
kubectl get pods -o wide
# Make sure you see the pod running on the 3rd CP node.
kubectl delete -f noscheduler-busybox.yaml
```

## 50.
Ongoing. Please continue experimenting with the cluster.