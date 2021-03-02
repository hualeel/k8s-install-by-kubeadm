#!/bin/bash
# 安装依赖包
yum install -y epel-release
yum install -y chrony conntrack ipvsadm ipset jq iptables curl sysstat libseccomp wget socat git

#关闭swap
swapoff -a
sed  -i -r '/swap/s/^/#/' /etc/fstab
free -m

#关闭防火墙
systemctl stop firewalld.service
systemctl disable firewalld.service
iptables -F && iptables -X && iptables -F -t nat && iptables -X -t nat
iptables -P FORWARD ACCEPT

#关闭selinux
setenforce 0
sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config
cat /etc/selinux/config  | grep -w "SELINUX"

#时间同步
yum -y install chrony
systemctl enable chronyd.service
systemctl start chronyd.service
sed -i -e '/^server/s/^/#/' -e '1a server ntp.aliyun.com iburst' /etc/chrony.conf
systemctl restart chronyd.service

#设置时区
timedatectl set-timezone Asia/Shanghai
systemctl enable chronyd
systemctl start chronyd
timedatectl set-local-rtc 0
systemctl restart rsyslog
systemctl restart crond

#修改内核参数
cat <<EOF | tee /etc/modules-load.d/k8s.conf
br_netfilter
EOF

cat <<EOF | tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
sudo sysctl --system
