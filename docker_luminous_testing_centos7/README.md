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


```
docker run -d --name demo -e MON_IP=0.0.0.0 -e CEPH_PUBLIC_NETWORK=0.0.0.0/0 --net=host -v /var/lib/ceph:/var/lib/ceph -v /etc/ceph:/etc/ceph -e CEPH_DEMO_UID=qqq -e CEPH_DEMO_ACCESS_KEY=qqq -e CEPH_DEMO_SECRET_KEY=qqq -e CEPH_DEMO_BUCKET=qqq ceph/daemon demo
```
