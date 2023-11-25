# What is it
Falco is a behavioral runtime activity monitor designed to detect anomalous activity in applications. It works by comparing syscalls against a rule set, and alerting when a rule is matched.

In Kubernertes context - Falco can be used to detect anomalous activity in your cluster, in the containers that are making system calls. 

# Installation

# Logs
```bash
# When configured for syslog
cat /var/log/syslog | grep falco
```