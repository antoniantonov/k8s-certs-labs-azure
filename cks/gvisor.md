# What is it
gVisor is a user-space kernel, written in Go, that implements a substantial portion of the Linux system surface. It includes an Open Container Initiative (OCI) runtime called runsc that provides an isolation boundary between the application and the host kernel. The runsc runtime integrates with Docker and Kubernetes, making it simple to run sandboxed containers.

# How to run a container with gVisor

Create first a runtime class for gvisor
https://kubernetes.io/docs/concepts/containers/runtime-class/#2-create-the-corresponding-runtimeclass-resources
```yaml
apiVersion: node.k8s.io/v1
kind: RuntimeClass
metadata:
  # The name the RuntimeClass will be referenced by.
  # RuntimeClass is a non-namespaced resource.
  name: mygvisorclass 
# The name of the corresponding CRI configuration
handler: runsc 
```

Create pod with runtimeClassName property
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: mypod
spec:
  # Reference the RuntimeClass created above.
  runtimeClassName: mygvisorclass
...
```
```bash
k create -f mygvisorclass.yaml
k create -f mypod.yaml
# This should return very view log entries compare to container that runs outside of the sandbox.
k exec mypod -- dmesg | grep runsc
```