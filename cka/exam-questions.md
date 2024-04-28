1.
Create a namespace called 'development' and a pod with image nginx called nginx on this namespace.
```bash
kubectl create namespace development
kubectl run nginx --image=nginx --restart=Never -n development
```

2.
Create a nginx pod with label env=test in engineering namespace See the solution below.
```bash
kubectl run nginx --image=nginx --restart=Never --labels=env=test --namespace=engineering --dry- run -o yaml > nginx-pod.yaml
kubectl run nginx --image=nginx --restart=Never --labels=env=test --namespace=engineering --dry- run -o yaml | kubectl create -n engineering -f ­
```

```yaml
apiVersion: v1
kind: Pod
metadata:
name: nginx
namespace: engineering
labels:
env: test
spec:
containers:
- name: nginx
image: nginx

imagePullPolicy: IfNotPresent
restartPolicy: Never
```

```bash
kubectl create -f nginx-pod.yaml
```

3.
Get list of all pods in all namespaces and write it to file "/opt/pods-list.yaml"
```bash
kubectl get po ­all-namespaces > /opt/pods-list.yaml
```

4.
Create a pod with image nginx called nginx and allow traffic on port 80
```bash
kubectl run nginx --image=nginx --restart=Never --port=80
```

17.
Check the Image version of nginx-dev pod using jsonpath
```bash
kubectl get po nginx-dev -o jsonpath='{.spec.containers[].image}{"\n"}'
```

18.
Create a busybox pod and add "sleep 3600" command
```bash
kubectl run busybox --image=busybox --restart=Never -- /bin/sh -c "sleep 3600"
```

19.
Create an nginx pod and list the pod with different levels of verbosity
```bash
kubectl run nginx --image=nginx --restart=Never --port=80 
# List the pod with different verbosity
kubectl get po nginx --v=7
kubectl get po nginx --v=8
kubectl get po nginx --v=9
```

20.
List the nginx pod with custom columns POD_NAME and POD_STATUS
```bash
kubectl get po -o=custom-columns="POD_NAME:.metadata.name, POD_STATUS:.status.containerStatuses[].state"
```

21.
List all the pods sorted by name
```bash
kubectl get pods --sort-by=.metadata.name
```

22.
List all the pods sorted by created timestamp
```bash
kubectl get pods --sort-by=.metadata.creationTimestamp
```

23.
List all the pods showing name and namespace with a json path expression
```bash
kubectl get pods -o=jsonpath="{.items[*]['metadata.name', 'metadata.namespace']}"
```

24.
List "nginx-dev" and "nginx-prod" pod and delete those pods
```bash
kubectl get pods nginx-dev nginx-prod -o wide
kubectl delete po "nginx-dev"
kubectl delete po "nginx-prod"
```

25.
Delete the pod without any delay (force delete)
```bash
kubectl delete po "POD-NAME" --grace-period=0 ­force
```

26.
Create a redis pod and expose it on port 6379
```bash
kubectl run redis --image=redis --restart=Never --port=6379
```
```yaml
apiVersion: v1
kind: Pod
metadata:
labels:
run: redis
name: redis
spec:
containers:
- image: redis
name: redis
ports:
- containerPort: 6379
restartPolicy: Always
```

27.
Create the nginx pod with version 1.17.4 and expose it on port 80
```bash
kubectl run nginx --image=nginx:1.17.4 --restart=Never --port=80
```

28.
Change the Image version to 1.15-alpine for the pod you just created and verify the image version is updated.

```bash
Kubectl set image pod/nginx nginx=nginx:1.15-alpine
kubectl describe po nginx
# another way it will open vi editor and change the version kubectl edit po nginx and then kubectl apply
```

29.
Change the Image version back to 1.17.1 for the pod you just updated and observe the changes
```bash
kubectl set image pod/nginx nginx=nginx:1.17.1
kubectl describe po nginx
kubectl get po nginx -w # watch it
```

30.
Create a redis pod, and have it use a non-persistent storage Note: In exam, you will have access to kubernetes.io site, Refer : https://kubernetes.io/docs/tasks/configure-pod-container/configurevolume-storage/

```yaml
apiVersion: v1
kind: Pod
metadata:
name: redis
spec:
containers:
- name: redis
image: redis
volumeMounts:
- name: redis-storage
mountPath: /data/redis
ports:
- containerPort: 6379
volumes:
- name: redis-storage
emptyDir: {}
```

31.
Create a Pod with three busy box containers with commands "ls; sleep 3600;", "echo Hello World; sleep 3600;" and "echo this is the third container; sleep 3600" respectively and check the status

Solution:

// first create single container pod with dry run flag 
```bash
kubectl run busybox --image=busybox --restart=Always --dry-run -o yaml -- bin/sh -c "sleep 3600; ls" > multi-container.yaml
```

Edit the pod to following yaml and create it
```yaml
apiVersion: v1
kind: Pod
metadata:
labels:
run: busybox
name: busybox
spec:
containers:
- args:
- bin/sh
- -c
- ls; sleep 3600
image: busybox
name: busybox-container-1
- args:
- bin/sh
- -c
- echo Hello world; sleep 3600
image: busybox
name: busybox-container-2
- args:
- bin/sh
- -c
- echo this is third container; sleep 3600
image: busybox
name: busybox-container-3
restartPolicy: Always
```
```bash
# Verify
Kubectl get pods
```

32.
Check logs of each container that "busyboxpod-{1,2,3}"

```bash
kubectl logs busybox -c busybox-container-1
kubectl logs busybox -c busybox-container-2
kubectl logs busybox -c busybox-container-3
```

33.
Create a Pod with main container busybox and which executes this "while true; do echo `Hi I am from Main container' >> /var/log/index.html; sleep 5; done" and with sidecar container with nginx image which exposes on port 80. Use emptyDir Volume and mount this volume on path /var/log for busybox and on path /usr/share/nginx/html for nginx container. Verify both containers are running.

```bash
# create an initial yaml file with this
kubectl run multi-cont-pod --image=busybox --restart=Never -- dry-run -o yaml > multi-container.yaml
# edit the yml as below and create it
kubectl create -f multi-container.yaml
vim multi-container.yaml
```

```yaml
apiVersion: v1
kind: Pod
metadata:
labels:
run: multi-cont-pod
name: multi-cont-pod
spec:
volumes:
- name: var-logs
emptyDir: {}
containers:
- image: busybox
command: ["/bin/sh"]
args: ["-c", "while true; do echo 'Hi I am from Main container' >> /var/log/index.html; sleep 5;done"]
name: main-container
volumeMounts:
- name: var-logs
mountPath: /var/log
- image: nginx
name: sidecar-container
ports:
- containerPort: 80
volumeMounts:
- name: var-logs
mountPath: /usr/share/nginx/html
restartPolicy: Never
```

```bash
# Create Pod
kubectl apply -f multi-container.yaml
# Verify
kubectl get pods
```

34.

35.
Create an nginx pod and set an env value as 'var1=val1'. Check the env value existence within the pod

```bash
kubectl run nginx --image=nginx --restart=Never --env=var1=val1 # then
kubectl exec -it nginx -- env
# or
kubectl exec -it nginx -- sh -c 'echo $var1'
# or
kubectl describe po nginx | grep val1
# or
kubectl run nginx --restart=Never --image=nginx --env=var1=val1 -it --rm ­ env
```

36.
## Create this exercise!!!
Create a pod with init container which create a file "test.txt" in "workdir" directory. Main container should check a file "test.txt" exists and execute sleep 9999 if the file exists.
```bash
# create an initial yaml file with this
kubectl run init-cont-pod --image=alpine --restart=Never --dry-run -o yaml > init-cont-pod.yaml
# edit the yml as below and create it
vim init-cont-pod.yaml
```

```yaml
apiVersion: v1
kind: Pod
metadata:
name: init-cont-pod
labels:
app: myapp
spec:
volumes:
- name: test-volume
emptyDir: {}
containers:
- name: main-container
image: busybox:1.28
command: ['sh', '-c', 'if [ -f /workdir/test.txt ]; then sleep 9999; fi']
volumeMounts:
- name: test-volume
mountPath: /workdir
initContainers:
- name: init-myservice
image: busybox:1.28
command: ['sh', '-c', "mkdir /workdir; echo > /workdir/test.txt"]
volumeMounts:
- name: test-volume
mountPath: /workdir
```

```bash
# Create the pod
kubectl apply -f init-cont-pod.yaml
kubectl get pods
# Check Events by doing
kubectl describe po init-cont-pod
```

Init Containers:
init-myservice:
Container ID:
docker://ebdbf5fad1c95111d9b0e0e2e743c2e347c81b8d4eb5abcccdfe1dd74524 0d4f
Image: busybox:1.28
Image ID: dockerpullable://busybox@sha256:141c253bc4c3fd0a201d32dc1f493bcf3fff003b6df 416dea4f41046e0f37d47
Port: <none>
Host Port: <none>
Command:
sh
-c
mkdir /workdir; echo > /workdir/test.txt


State: Terminated
Reason: Completed

37.
## Create this exercise!!!
Create a pod with init container which waits for a service called "myservice" to be created. Once init container completes, the myapp-container should start and print a message "The app is running" and sleep for 3600 seconds.

```bash
vim multi-container-pod.yaml
```

```yaml
apiVersion: v1
kind: Pod
metadata:
name: myapp-pod
labels:
app: myapp
spec:
containers:
- name: myapp-container
image: busybox:1.28
command: ['sh', '-c', 'echo The app is running! && sleep 3600']
initContainers:
- name: init-myservice
image: busybox:1.28
command: ['sh', '-c', "until nslookup myservice.$(cat /var/run/secrets/kubernetes.io/serviceaccount/namespace).s vc.cluster.local; do echo waiting for myservice; sleep 2; done"]
```

```bash
# Check whether service called "myservice" exists
kubectl get svc
# Note: Pod will not start if service called "myservice" doesn't exist.
# Now, Create the pod
kubectl apply -f multi-container-pod.yaml
```

38.
Create 5 nginx pods in which two of them is labeled env=prod and three of them is labeled env=dev
    
```bash
kubectl run nginx-dev1 --image=nginx --restart=Never -- labels=env=dev
kubectl run nginx-dev2 --image=nginx --restart=Never -- labels=env=dev
kubectl run nginx-dev3 --image=nginx --restart=Never -- labels=env=dev
kubectl run nginx-prod1 --image=nginx --restart=Never -- labels=env=prod
kubectl run nginx-prod2 --image=nginx --restart=Never -- labels=env=prod
```

39.
Get the pods with label env=dev and output the labels
```bash
kubectl get pods -l env=dev --show-labels
```

40.
Get the pods with labels env=dev and env=prod and output the labels as well
```bash
kubectl get pods -l 'env in (dev,prod)' --show-labels
```

41.
Get all the pods with label "env"
```bash
kubectl get pods -L env
```

42.
Change the label for one of the pod to env=uat and list all the pods to verify
```bash
kubectl label pod/nginx-dev3 env=uat --overwrite
kubectl get pods --show-labels
```

43.
Get list of all the nodes with labels
```bash
kubectl get nodes --show-labels
```

44.
Create a nginx pod that will be deployed to node with the label "gpu=true"
```bash
kubectl run nginx --image=nginx --restart=Always --dry-run -o yaml > nodeselector-pod.yaml
# add the nodeSelector like below and create the pod kubectl apply -f nodeselector-pod.yaml
vim nodeselector-pod.yaml
```

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: nginx
spec:
nodeSelector:
  gpu: true
containers:
- image: nginx
  name: nginx
  restartPolicy: Always
```

```bash
kubectl apply -f nodeselector-pod.yaml
#Verify
kubectl get po --­show-labels
kubectl get po
kubectl describe po nginx | grep Node-Selectors
```

45.
Annotate the pod with name=webapp
```bash
kubectl annotate pod nginx-dev-pod name=webapp
kubectl annotate pod nginx-prod-pod name=webapp
# Verify
kubectl describe po nginx-dev-pod | grep -i annotations 
kubectl describe po nginx-prod-pod | grep -i annotations
```

46.
Create a deployment called webapp with image nginx having 5 replicas in it, put the file in /tmp directory with named webapp.yaml
```bash
# Create a file using dry run command
kubectl create deploy --image=nginx --dry-run -o yaml > /tmp/webapp.yaml
# Now, edit file webapp.yaml and update replicas=5

vim /tmp/webapp.yaml
```

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
labels:
app: webapp
name: webapp
spec:
replicas: 5
selector:
matchLabels:
app: webapp
template:
metadata:
labels:
app: webapp
spec:
containers:
- image: nginx
name: nginx
```

```bash
kubectl create -f /tmp/webapp.yaml
# Note: Search "deployment" in kubernetes.io site , you will get the page
# https://kubernetes.io/docs/concepts/workloads/controllers/deployment/
# Verify the Deployment
kubectl get deploy webapp --show-labels
# Output the YAML file of the deployment webapp
kubectl get deploy webapp -o yaml
```

47.
Get the list of pods of webapp deployment
```bash
# Get the label of the deployment
kubectl get deploy --show-labels
# Get the pods with that label
kubectl get pods -l app=webapp
```

48.
Scale the deployment from 5 replicas to 20 replicas and verify
```bash
kubectl scale deploy webapp --replicas=20
kubectl get deploy webapp
kubectl get po -l app=webapp
```

49.
Get the deployment rollout status
```bash
kubectl rollout status deploy webapp
```

50.
Create a deployment of webapp with image nginx:1.17.1 with container port 80 and verify the image version
```bash
# Create initial YAML file with ­dry-run option
kubectl create deploy webapp --image=nginx:1.17.1 --dryrun=client -o yaml > webapp.yaml 
vim webapp.yaml
```

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
labels:
app: webapp
name: webapp
spec:
replicas: 1
selector:
matchLabels:
app: webapp
template:
metadata:
labels:
app: webapp
spec:
containers:
- image: nginx:1.17.1
name: nginx
```

```bash
kubectl create -f webapp.yaml
# Verify Image Version
kubectl describe deploy webapp | grep -i "Image"
# Using JsonPath
kubectl get deploy -o=jsonpath='{range.items [*]}{.[*]} {.metadata.name}{"\t"}{.spec.template.spec.containers[*].image}{"\n"}'
```

51.
Update the deployment with the image version 1.17.4 and verify
```bash
kubectl set image deploy/webapp nginx=nginx:1.17.4
# Verify
kubectl describe deploy webapp | grep Image
kubectl get deploy -o=jsonpath='{range.items [*]}{.[*]} {.metadata.name}{"\t"}{.spec.template.spec.containers[*].i mage}{"\n"}'
```

52.
Check the rollout history and make sure everything is ok after the update
```bash
kubectl rollout history deploy webapp
kubectl get deploy webapp --show-labels
kubectl get rs -l app=webapp
kubectl get po -l app=webapp
```

53.
Undo the deployment to the previous version 1.17.1 and verify Image has the previous version
```bash
kubectl rollout undo deploy webapp
kubectl describe deploy webapp | grep Image
kubectl get deploy -o=jsonpath='{range.items [*]}{.[*]} {.metadata.name}{"\t"}{.spec.template.spec.containers[*].i mage}{"\n"}'
```

54.
Update the deployment with the image version 1.16.1 and verify the image and check the rollout history
```bash
kubectl set image deploy/webapp nginx=nginx:1.16.1
kubectl describe deploy webapp | grep Image
kubectl rollout history deploy webapp
```

55.
Check the history of deployment
```bash
kubectl rollout history deployment webapp
```

56.
Undo the deployment with the previous version and verify everything is Ok
```bash
kubectl rollout undo deploy webapp
kubectl rollout status deploy webapp
kubectl get pods
```

57.
Undo/Rollback deployment to specific revision "1"
```bash
# Check Deployment History
kubectl rollout history deployment webapp
# Rollback to particular revision
kubectl rollout undo deployment webapp --to-revision=1
# Verify
kubectl rollout history deployment webapp
```

58.
Check the history of the specific revision of that deployment
```bash
kubectl rollout history deploy webapp --revision=3
```

59.
Pause the rollout of the deployment
```bash
kubectl rollout pause deploy webapp
```

60.
Resume the rollout of the deployment
```bash
kubectl rollout resume deploy webapp
```

61.
Scale the deployment to 5 replicas
```bash
kubectl scale deployment webapp ­replicas=5
# Verify
kubectl get deploy webapp
kubectl get po,rs webapp
```

62.
Scale down the deployment to 1 replica
```bash
kubectl scale deployment webapp ­replicas=1
# Verify
kubectl get deploy
kubectl get po,rs
```

63.
Apply the autoscaling to this deployment with minimum 10 and maximum 20 replicas and target CPU of 85% and verify hpa is created and replicas are increased to 10 from 1
```bash
kubectl autoscale deploy webapp --min=10 --max=20 --cpu percent=85
# More info: https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale/
kubectl get hpa
kubectl get pod -l app=webapp
```

64.
Clean the cluster by deleting deployment and hpa you just Created
```bash
kubectl delete deploy webapp
kubectl delete hpa webapp
```
