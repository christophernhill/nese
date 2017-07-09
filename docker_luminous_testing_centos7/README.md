- Testing notes for Docker demo of Luminous

- OS host source

```
   curl http://mirror.cc.columbia.edu/pub/linux/centos/7/isos/x86_64/CentOS-7-x86_64-Minimal-1611.iso > CentOS-7-x86_64-Minimal-1611.iso
```
   
- Install in Virtual Box

configure with two network cards, one NAT and one host only

```
systemctl enable sshd
systemctl start sshd
```
   
- Add docker (in VM)
```
yum install -y yum-utils device-mapper-persistent-data lvm2
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
    
## yum-config-manager --enable docker-ce-edge
## yum-config-manager --disable docker-ce-edge

yum makecache fast
yum install docker-ce

systemctl start docker
docker run hello-world

```
