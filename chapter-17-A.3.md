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
Use the [foodie.yaml](./files/foodie.yaml) file.