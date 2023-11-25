# What is it?
Network policies are a Kubernetes feature that lets you configure how groups of pods are allowed to communicate with each other and other network endpoints. Network policies are implemented by the network plugin and only network plugins that implement them support them. In addition, network policies only apply to pods, not to nodes.

# CIDR notation
https://mxtoolbox.com/subnetcalculator.aspx
https://account.arin.net/public/cidrCalculator 

# Single IP
Allow all egress traffic except single IP - 1.1.1.1.
```yaml
...
egress:
  - to:
    - ipBlock:
        cidr: 0.0.0.0/0
        except:
          - 1.1.1.1/32
...
```