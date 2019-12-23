# kubernetes-glusterfs
Glusterfs installation and Kubernetes StorageClass configuration

## Glusterfs Installation Steps

### Ubuntu

- Create a Ubuntu 16.04 VM.

- Attach a blank disk to VM.

- Run the commands below to install glusterfs on Ubuntu.

```
sudo apt-get -y update
sudo apt-get -y install thin-provisioning-tools
sudo apt-get -y install software-properties-common
sudo apt-get -y install glusterfs-server 
sudo service glusterfs-server start
```

- Run the command below to add disk device. (Optional)

```
sudo fdisk /dev/sdb

n for new partition
p for primary partition
1 for partition number
first and last sectors can be default, just press enter
w for saving changes
```

- Run "sudo fdisk -l" and see new /dev/sdb1 device. (Optional)

### CentOS

- Create a CentOS 7 VM.

- Attach a blank disk to VM.

- Run the commands below to install glusterfs on CentOS.

```
yum -y install centos-release-gluster
yum -y install glusterfs-server
systemctl enable glusterd
systemctl start glusterd
```

- Run the command below to add disk device. (Optional)

```
fdisk /dev/sdb

n for new partition
p for primary partition
1 for partition number
first and last sectors can be default, just press enter
w for saving changes
```

- Run "fdisk -l" and see new /dev/sdb1 device. (Optional) 

## Heketi Installation Steps

### Ubuntu Installation Steps

- Run the commands below to install heketi on Ubuntu.

```
wget https://github.com/heketi/heketi/releases/download/v8.0.0/heketi-v8.0.0.linux.amd64.tar.gz
tar -xvzf heketi-v8.0.0.linux.amd64.tar.gz
cd heketi
sudo mv heketi heketi-cli /usr/local/bin
sudo groupadd -r -g 515 heketi
sudo useradd -r -c "Heketi user" -d /var/lib/heketi -s /bin/false -m -u 515 -g heketi heketi
sudo mkdir -p /var/lib/heketi && sudo chown -R heketi:heketi /var/lib/heketi
sudo mkdir -p /var/log/heketi && sudo chown -R heketi:heketi /var/log/heketi
sudo mkdir -p /etc/heketi
```

- Run the commands below to configure root SSH authentication for heketi.

```
sudo su
ssh-keygen -f /etc/heketi/heketi_key -t rsa -N ''
chown heketi:heketi /etc/heketi/heketi_key*
cat /etc/heketi/heketi_key.pub >> /root/.ssh/authorized_keys
```

- Switch back to ubuntu user and update heketi config. See heketi/heketi.json file.

- Create a topology json file. See heketi/topology.json file.

- Change glusterfs-server service name to glusterd and start glusterd, heketi with commands below.

```
sudo mv /etc/init.d/glusterfs-server /etc/init.d/glusterd
sudo systemctl daemon-reload
sudo heketi --config=heketi.json
```

- In another session run:

```
heketi-cli topology load --json=topology.json
```

### CentOS Installation Steps

- Run the commands below to install heketi on CentOS.

```
yum -y install heketi
yum -y install heketi-client
mkdir -p /var/lib/heketi && chown -R heketi:heketi /var/lib/heketi
mkdir -p /var/log/heketi && chown -R heketi:heketi /var/log/heketi
mkdir -p /etc/heketi
```

- Run the commands below to configure root SSH authentication for heketi.

```
ssh-keygen -f /etc/heketi/heketi_key -t rsa -N ''
chown heketi:heketi /etc/heketi/heketi_key*
cat /etc/heketi/heketi_key.pub >> /root/.ssh/authorized_keys
```

- Create a heketi config file. See heketi/heketi.json file.

- Create a topology json file. See heketi/topology.json file.

- In another session run:

```
heketi-cli topology load --json=topology.json
```

## Kubernetes Configuration

- Install glusterfs-client on Kubernetes worker nodes.

Ubuntu:
```
sudo apt-get -y install glusterfs-client
```

CentOS:
```
yum -y install glusterfs glusterfs-fuse
```

- Run the commands below to create storage class and persistentvolumeclaim.

```
kubectl apply -f kube/storageclass.yml
kubectl apply -f kube/pvc.yml
```

- See the example kube/nginx-glusterfs.yml file.