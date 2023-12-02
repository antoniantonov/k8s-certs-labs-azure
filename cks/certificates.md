# Create new user for Kubernetes
https://kubernetes.io/docs/reference/access-authn-authz/certificate-signing-requests/#normal-user
```bash
# Create private key and certificate signing request
openssl genrsa -out user.key 2048
openssl req -new -key user.key -out user.csr -subj "/CN=myuser@users"
```

Approve and sign the CSR via Kubernetes API
```bash
# Get one liner base64 encoded CSR
cat user.csr | base64 | tr -d "\n"

cat <<EOF | kubectl apply -f -
apiVersion: certificates.k8s.io/v1
kind: CertificateSigningRequest
metadata:
  name: myuser
spec:
  # Request here is the base64 encoded version of the CSR file contents.

  request: LS0tLS1CRUdJTiBDRVJUSUZJQ0FURSBSRVFVRVNULS0tLS0KTUlJQ1....LS0tLQo=
  signerName: kubernetes.io/kube-apiserver-client
  expirationSeconds: 86400  # one day
  usages:
  - client auth
EOF

# Approve the CSR
kubectl get csr
kubectl certificate approve myuser

# Extract the certificate for the user
kubectl get csr myuser -o jsonpath='{.status.certificate}'| base64 -d > user.crt
```

Manually approve and sign the CSR via openssl
```bash
# Find the required cluster authority certificate and key
find /etc/kubernetes/pki | grep ca
# /etc/kubernetes/pki/ca.crt
# /etc/kubernetes/pki/ca.key

# Manually signed and approve the CSR
openssl x509 -req -in user.csr -CA /etc/kubernetes/pki/ca.crt -CAkey /etc/kubernetes/pki/ca.key -CAcreateserial -out user.crt -days 500
```

```bash
# Add credentials to kubeconfig file
kubectl config set-credentials myuser --client-key=user.key --client-certificate=user.crt --embed-certs=true
# Add context
kubectl config set-context myuser --cluster=kubernetes --user=myuser
kubectl config use-context myuser
```

# TLS version for different components
Set TLS version for kube-apiserver, ETCD and kubelet
```bash
# Update /etc/kubernetes/manifests/kube-apiserver.yaml and verify
- --tls-min-version=VersionTLS13
openssl s_client -connect 127.0.0.1:6443 -tls1_3

# Update /etc/kubernetes/manifests/etcd.yaml and verify
# https://etcd.io/docs/v3.5/op-guide/configuration/#security
- --tls-min-version=TLS1.3
openssl s_client -connect 127.0.0.1:2379 -tls1_3

# /var/lib/kubelet/config.yaml - do this on all nodes and restart kubelet
echo "tlsMinVersion: VersionTLS13" | sudo tee -a /var/lib/kubelet/config.yaml
sudo systemctl restart kubelet
openssl s_client -connect 127.0.0.1:10250 -tls1_3
```