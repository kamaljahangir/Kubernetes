#!/bin/bash
#k8s
#
setenforce 0
sed -i 's/SELINUX=enforcing/SELINUX=disabled/'  /etc/selinux/config
modprobe br_netfilter
echo '1' > /proc/sys/net/bridge/bridge-nf-call-iptables
swapoff  -a
firewall-cmd --add-port=0-65535/tcp --permanent
firewall-cmd --add-port=0-65535/udp --permanent
firewall-cmd --reload
cp -i ./kube.repo /etc/yum.repos.d/
yum install docker kubeadm -y
systemctl enable --now docker kubelet
kubeadm init --pod-network-cidr=192.168.0.0/16
mkdir -p $HOME/.kube
cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
chown $(id -u):$(id -g) $HOME/.kube/config
kubectl apply -f https://docs.projectcalico.org/v3.8/manifests/calico.yaml
