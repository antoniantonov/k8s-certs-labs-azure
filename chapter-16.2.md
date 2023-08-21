# High availability 

## Using VMs on Azure to achieve high availability
When all the VMs are on Azure, make sure the vnet security group allows inbound and outbound traffic within the vnet. Same for individual VMs firewalls.

To find out the local VNet IP of a server use the following command:
```bash
# Run on your primary CP server
hostname -I
# 10.3.0.4
```

Use this IP address to add it here:
```bash
sudo vim /etc/haproxy/haproxy.cfg

# The port should be open for inbound and outbound traffic within the vnet
#
# balance roundrobin
# server cp  10.3.0.4:6443 check  #<-- Edit these with your IP addresses, port, and hostname
```