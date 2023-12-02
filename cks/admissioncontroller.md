# What is admission controller web hooks?

Admission controller web hooks are HTTP callbacks that receive admission requests and do something with them. You can define two types of admission web hooks, validating admission web hooks, and mutating admission web hooks.

# Configuring admission controller for scanning images
```bash
# look up where the configuration file is stored
cat /etc/kubernetes/manifests/kube-apiserver.yaml | grep admission-control-config-file

# look up the configuration file based on previous command.
cat /etc/kubernetes/policywebhook/admission_config.json
```

Enable ImagePolicyWebhook admission controller
```yaml
...
- command:
  - kube-apiserver
  - --enable-admission-plugins=NodeRestriction,ImagePolicyWebhook
  - --admission-control-config-file=/etc/kubernetes/policywebhook/admission_config.json
...
```

Admission controller configuration for ImagePolicyWebhook
```json
# /etc/kubernetes/policywebhook/admission_config.json
{
   "apiVersion": "apiserver.config.k8s.io/v1",
   "kind": "AdmissionConfiguration",
   "plugins": [
      {
         "name": "ImagePolicyWebhook",
         "configuration": {
            "imagePolicy": {
                # This is kubeconfig file that will allow kube-apiserver connection.
               "kubeConfigFile": "/etc/kubernetes/policywebhook/kubeconf",
               "allowTTL": 100,
               "denyTTL": 50,
               "retryBackoff": 500,
               "defaultAllow": false
            }
         }
      }
   ]
}
```

Kubeconfig file for ImagePolicyWebhook
```yaml
apiVersion: v1
kind: Config

# clusters refers to the remote service.
clusters:
- cluster:
    certificate-authority: /etc/kubernetes/policywebhook/external-cert.pem  # CA for verifying the remote service.
    server: https://localhost:1234                   # URL of remote service to query. Must use 'https'.
  name: image-checker

contexts:
- context:
    cluster: image-checker
    user: api-server
  name: image-checker
current-context: image-checker
preferences: {}

# users refers to the API server's webhook configuration.
users:
- name: api-server
  user:
    client-certificate: /etc/kubernetes/policywebhook/apiserver-client-cert.pem     # cert for the webhook admission controller to use
    client-key:  /etc/kubernetes/policywebhook/apiserver-client-key.pem             # key matching the cert
```

# Configuring admission controller for Node restrictions
```bash
# Run as kubelet user from a node.
export KUBECONFIG=/etc/kubernetes/kubelet.conf

# Try label node other than the current - this should fail if running from a node other than the controlplane.
kubectl label node controlplane node-role.kubernetes.io/master=master

# This should fail even for its own node - special label.
kubectl label node node1 node-restriction.kubernetes.io/abc=123
```