# Ingress controller 

# Install ingress controller
https://kubernetes.github.io/ingress-nginx/deploy/#quick-start
```bash
# Using helm
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update
helm install ingress-nginx ingress-nginx/ingress-nginx --namespace ingress-nginx --create-namespace
```

# mTLS with Ingress controller
https://kubernetes.io/docs/concepts/services-networking/ingress/#tls
```bash
# Subject needs to match the ingress host name inside the ingress resource.
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout cert.key -out cert.crt -subj "/CN=world.universe.mine/O=world.universe.mine"
kubectl -n world create secret tls ingress-tls --key cert.key --cert cert.crt
```

Sample ingress resource with TLS
```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: world
  namespace: world
  annotations:
    nginx.ingress.kubernetes.io/ssl-redirect: "false"
    nginx.ingress.kubernetes.io/use-regex: "true"
    nginx.ingress.kubernetes.io/rewrite-target: /$1
spec:
  ingressClassName: nginx
  tls:                            # add
  - hosts:                        # add
    - world.universe.mine         # add
    secretName: ingress-tls       # add
  rules:
  - host: "world.universe.mine"
    http:
      paths:
      - path: /europe
        pathType: Prefix
        backend:
          service:
            name: europe
            port:
              number: 80
      - path: /asia
        pathType: Prefix
        backend:
          service:
            name: asia
            port:
              number: 80
```