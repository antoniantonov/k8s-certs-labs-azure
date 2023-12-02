# What is it
https://github.com/strace/strace
This is strace -- a diagnostic, debugging and instructional userspace utility with a traditional command-line interface for Linux. It is used to monitor and tamper with interactions between processes and the Linux kernel, which include system calls, signal deliveries, and changes of process state.

# Check sys calls made by K8s apiserver process
```bash
# Get the pid of apiserver process
ps aux | grep kube-apiserver

# This will generate a lot of output
strace -p 19890 -f # use the PID of apiserver process

# Run this for a little bit and then ctrl+c
strace -p 19890 -f -cw # use your PID of apiserver process
```

Check sys calls made by a process using strace
```bash
# 2>&1 -> Redirects the stderr to stdout (standard error to standard output)
strace kill -9 1234 2>&1 | grep 1234
```