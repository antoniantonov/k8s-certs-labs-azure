# What is it
Falco is a behavioral runtime activity monitor designed to detect anomalous activity in applications. It works by comparing syscalls against a rule set, and alerting when a rule is matched.

In Kubernertes context - Falco can be used to detect anomalous activity in your cluster, in the containers that are making system calls. 

# Installation

# Logs
```bash
# When configured for syslog
cat /var/log/syslog | grep falco
```


# Use falco from command line
Only if the service is disabled
```bash
service falco status
service falco stop
falco
Thu Sep 16 06:33:11 2021: Falco version 0.29.1 (driver version 17f5df52a7d9ed6bb12d3b1768460def8439936d)
Thu Sep 16 06:33:11 2021: Falco initialized with configuration file /etc/falco/falco.yaml
Thu Sep 16 06:33:11 2021: Loading rules from file /etc/falco/falco_rules.yaml:
Thu Sep 16 06:33:11 2021: Loading rules from file /etc/falco/falco_rules.local.yaml:
Thu Sep 16 06:33:11 2021: Loading rules from file /etc/falco/k8s_audit_rules.yaml:
Thu Sep 16 06:33:12 2021: Starting internal webserver, listening on port 8765
06:33:17.382603204: Error Package management process launched in container (user=root user_loginuid=-1 command=apk container_id=7a5ea6a080d1 container_name=nginx image=docker.io/library/nginx:1.19.2-alpine)
```

Run falco with specific rules file for 45 seconds:
```bash
sudo falco -M 45 -r monitor_rules.yml > falco_output.log
```

How to find out what are the rules that are being used by falco from syslog?
```bash
cat /var/log/syslog | grep falco

Nov 29 12:48:01 controlplane kernel: [ 1225.086248] falco: loading out-of-tree module taints kernel.
Nov 29 12:48:01 controlplane kernel: [ 1225.086494] falco: module verification failed: signature and/or required key missing - tainting kernel
Nov 29 12:48:01 controlplane kernel: [ 1225.087887] falco: driver loading, falco 2.0.0+driver
Nov 29 12:48:01 controlplane falco: Falco version 0.32.1
Nov 29 12:48:01 controlplane falco: Falco initialized with configuration file /etc/falco/falco.yaml
Nov 29 12:48:01 controlplane falco[40574]: Wed Nov 29 12:48:01 2023: Falco version 0.32.1
Nov 29 12:48:01 controlplane falco[40574]: Wed Nov 29 12:48:01 2023: Falco initialized with configuration file /etc/falco/falco.yaml
Nov 29 12:48:01 controlplane falco: Loading rules from file /etc/falco/falco_rules.yaml:
Nov 29 12:48:01 controlplane falco[40574]: Wed Nov 29 12:48:01 2023: Loading rules from file /etc/falco/falco_rules.yaml:
Nov 29 12:48:02 controlplane falco: Loading rules from file /etc/falco/falco_rules.local.yaml:
Nov 29 12:48:02 controlplane falco[40574]: Wed Nov 29 12:48:02 2023: Loading rules from file /etc/falco/falco_rules.local.yaml:
Nov 29 12:48:02 controlplane falco: Starting internal webserver, listening on port 8765
Nov 29 12:48:02 controlplane falco[40574]: Wed Nov 29 12:48:02 2023: Starting internal webserver, listening on port 8765
```