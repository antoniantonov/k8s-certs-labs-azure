# CKA course labs on Azure

## Chapter 3: Installation & Configuration

### Deploying VM on Azure
Before we begin, we need to deploy a VM on Azure for the control plane of Kubernetes.
```bash
az login --use-device-code
az account set --subscription xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
az group crate --name anton-cka-cks --location uksouth
# If unsure of the possible location values, run the following command:
# az account list-locations -o table
```