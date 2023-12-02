# Create pod security standard at cluster level
https://kubernetes.io/docs/tutorials/security/cluster-level-pss/

# Create pod security standard at namespace level
https://kubernetes.io/docs/tutorials/security/ns-level-pss/
https://kubernetes.io/docs/concepts/security/pod-security-standards/

```bash
kubectl create ns example
kubectl label --overwrite ns example \
   pod-security.kubernetes.io/warn=baseline \     # this is applying the base line standard.
   pod-security.kubernetes.io/warn-version=latest
```