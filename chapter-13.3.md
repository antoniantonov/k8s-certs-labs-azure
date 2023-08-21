# Adding tools for monitoring and metrics

## Installing Metrics server
There's an issue with the TLS configuration of the metrics server, so we need to disable it. This is not recommended for production environments, but it's fine for our lab. More info here: https://github.com/kubernetes-sigs/metrics-server/issues/196
```bash
# Patch the metrics server deployment
kubectl -n kube-system patch deployment metrics-server --type=json -p='[{"op": "add", "path": "/spec/template/spec/containers/0/args/-", "value": "--kubelet-insecure-tls"}]]'

# Restart the pods via rolling deployment rollout 
kubectl rollout restart deployment metrics-server -n kube-system
```