# Create persistent NFS volume and share it between nodes

## On CP node
```bash
# Install NSF kernel
sudo apt-get update && sudo apt-get install -y nfs-kernel-server

# Make directory to be shared
sudo mkdir /opt/sfw
sudo chmod 1777 /opt/sfw/
sudo bash -c 'echo software > /opt/sfw/hello.txt'

# Edit NFS server file to share the directory with all
sudo vim /etc/exports
/opt/sfw/ *(rw,sync,no_root_squash,subtree_check)
# Alternative of the above VIM command
sudo bash -c 'echo "/opt/sfw *(rw,sync,no_root_squash,no_subtree_check)" >> /etc/exports'

# Re-read the /ect/exports file
sudo exportfs -ra
```

## On the second node
```bash
# Install NFS client
sudo apt-get -y install nfs-common

# Mount the shared directory to /mnt 
showmount -e k8scp
sudo mount k8scp:/opt/sfw /mnt
ls -l /mnt
```