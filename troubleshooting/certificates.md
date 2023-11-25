# Certificates troubleshooting

## Certificates location
```bash
# API certs
find /etc/kubernetes/pki | grep apiserver

# ETCD certs
ls -la /etc/kubernetes/pki/etcd
```

## Check the certificate expiration date
```bash
openssl x509 -noout -text -in /etc/kubernetes/pki/apiserver.crt | grep Validity -A2
```

## Management with kubeadm

Expiration date:
```bash
kubeadm certs check-expiration
kubeadm certs check-expiration | grep apiserver
```

Renew certificates:
```bash
kubeadm certs renew all

kubeadm certs check-expiration  # To get the cert names
kubeadm certs renew apiserver
```
