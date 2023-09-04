# How to install NGINX ingress controller on Kubernetes
We will be using helm. Install helm if you haven't done so. [Instructions](https://helm.sh/docs/intro/install/).
```bash
# Add the official stable repository for nginx ingress controller
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update
helm fetch ingress-nginx/ingress-nginx --untar
vim ./ingress-nginx/values.yaml

# Inside the VIM editor, change the following:
## DaemonSet or Deployment3##
# kind: DaemonSet                      #<-- Change to DaemonSet

helm install myingress ./ingress-nginx/.
kubectl --namespace default get services -o wide -w myingress-ingress-nginx-controller
kubectl get pod --all-namespaces | grep nginx
```

You should be good to go. You can now create an ingress resource and test it out. [Instructions](https://kubernetes.io/docs/concepts/services-networking/ingress/)