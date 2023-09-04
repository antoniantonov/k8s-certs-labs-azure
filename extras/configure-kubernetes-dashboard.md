# How to configure Kubernetes dashboard

1. Install metric server and Kubernetes dashboard
```bash
git clone https://github.com/kubernetes-incubator/metrics-server.git
kubectl create -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
kubectl -n kube-system get pods
```

To allow insecure TLS edit the metric server configuration:
```bash
kubectl -n kube-system edit deployment metrics-server
# Add the following to the args section if it's not already there.
# --kubelet-insecure-tls
# --kubelet-preferred-address-types=InternalIP,ExternalIP,Hostname
```

Try the metrics server:
```bash
kubectl top pod --all-namespaces
```

Now install the dashboard. Find and 
```bash

2. Access Kubernetes dashboard from the web
- Generate token for the web sign-in by using the Kubernetes dashboard service account.
```bash
kubectl get serviceaccounts
kubectl create token mydashboard-kubernetes-dashboard
```
- Use the generated token above to sign-in to the web dashboard. Access dashboard from the web browser with the IP and port of the Kubernetes dashboard NodePort service.
```bash
kubectl get svc  mydashboard-kubernetes-dashboard
```