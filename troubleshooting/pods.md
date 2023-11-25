# Troubleshooting pods

## Resource utilization
When available cpu or memory resources on the nodes reach their limit, Kubernetes will look for Pods that are using more resources than they requested. These will be the first candidates for termination. If some Pods containers have no resource requests/limits set, then by default those are considered to use more than requested. <br>

Kubernetes assigns Quality of Service classes to Pods based on the defined resources and limits, read more here: https://kubernetes.io/docs/tasks/configure-pod-container/quality-service-pod
```bash
# Get all pods' requested resources
k describe pod -A | egrep "^(Name:|    Requests:)" -A1
```