# What is OPA (Open Policy Agent)?
OPA is a general-purpose policy engine that can be used to enforce policies across the stack. It is a CNCF project and it is used by many companies including Netflix, Pinterest, and others.

# Install OPA
```bash
```

# How to find out OPA constraints?
```bash
kubectl get crd -A
kubectl get constraint -A
kubectl edit blacklistimages pod-trusted-images

kubectl get constrainttemplate -A
kubectl edit constrainttemplate blacklistimages

# If there are violations we can see the errors by doing:
kubectl get crd 
requieredlabels.k8s.gatekeeper.sh       2021-10-17T20:28:00Z

kubectl describe requiredlabels namespace-mandatory-labels
```
