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

# Find out process id (PID) using crictl for a given container
```bash
# get the container id -> 3bfd8f019282b
crictl ps | grep apiserver

# Run inspect and look for PID -> "pid": 31670
crictl inspect --output go-template --template '{{.info.pid}}' 3bfd8f019282b
crictl inspect 3bfd8f019282b | grep pid
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

Actually compare 2 hashes
```bash
# Write both hashes into a file as follows:
vim compare
# ./compare
60100cc725e91fe1a949e1b2d0474237844b5862556e25c2c655a33b0a8225855ec5ee22fa4927e6c46a60d43a7c4403a27268f96fbb726307d1608b44f38a60  
60100cc725e91fe1a949e1b2d0474237844b5862556e25c2c655a33boa8225855ec5ee22fa4927e6c46a60d43a7c4403a27268f96fbb726307d1608b44f38a60

# Compare the hashes - if these are the same only one line will be printed.
cat compare | uniq
```

# Syscalls
https://man7.org/linux/man-pages/man2/syscalls.2.html

# Find out what process is running in given container
 