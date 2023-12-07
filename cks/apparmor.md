# What is it?
Apparmor is a Linux kernel security module that allows the system administrator to restrict programs' capabilities with per-program profiles. Profiles can allow capabilities like network access, raw socket access, and the permission to read, write, or execute files on matching paths. Apparmor supplements the traditional Unix discretionary access control (DAC) model by providing mandatory access control (MAC). It has been included in the mainline Linux kernel since version 2.6.36 and its development has been supported by Canonical since 2009.

# How to find out if apparmor is enabled
```bash
# This should return a list of profiles
aa-status
apparmor_status
```

# Load specific profile
```bash
apparmor_parser /etc/apparmor.d/usr.bin.docker
# Check if it's loaded
apparmor_status
...
/etc/apparmor.d/usr.bin.docker
...
```

# Enforce specific profile
```bash
# -r => replace the profile already loaded.
apparmor_parser -r /etc/apparmor.d/usr.bin.docker
```

# Inspect if container is running with apparmor profile
```bash
crictl inspect CONTAINER-ID | grep apparmor
```

# How to use apparmor with containers
https://kubernetes.io/docs/tutorials/security/apparmor/#securing-a-pod
Load apparmor profile to a specific node.
```bash
kubectl label node node01 security=apparmor
ssh node01
apparmor_parser -r very-secure
```
```yaml
...
metadata:
      creationTimestamp: null
      labels:
        app: apparmor
      # This annotation is the crucial part: 
      # attention to the name of the container "c1" and the apparmor profile "very-secure" 
      annotations:
        container.apparmor.security.beta.kubernetes.io/c1: localhost/very-secure
    spec:
      nodeSelector:
        security: apparmor     # Make sure this is the node with apparmor profile loaded
      containers:
      - image: nginx:1.19.2
        name: c1
...
```