# What is this?
This file contains bunch of linux commands that are security orientated and can be used to preprate for CKS exam.

# What process is listening on a given port?

If we know the port, here's how to find out what process is listening on that port
```bash
# Using nettools
apt install net-tools
netstat -tulpan | grep 1234

# using lsof
lsof -i :1234
```

How to find out the full path to the process' binary?
```bash
ls -l /proc/17773/exe # use your ID instead
```

Finally, kill and delete the binary
```bash
kill 17773 # use your ID instead
rm /usr/bin/app1
```

# Binary hashes

How to compare binary hashes?
```bash
# compare hashes
whereis kubelet
sha512sum /usr/bin/kubelet

# This one has been downloaded from kubernetes.io
sha512sum kubernetes/server/bin/kubelet
```