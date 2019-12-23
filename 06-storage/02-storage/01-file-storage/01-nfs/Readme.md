#### NFS
```bash
yum -y install nfs-utils 
mkdir /nfsroot 
vim /etc/exports
```

Add the line below
```
 /nfsroot 192.168.5.0/24(ro,no_root_squash,no_subtree_check) 
```
```bash
exportfs -r 
/etc/init.d/nfs start 
showmount -e 
```
