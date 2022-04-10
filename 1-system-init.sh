#!/bin/bash
# 安装依赖包
yum install -y epel-release
yum install -y chrony conntrack ipvsadm ipset jq iptables curl sysstat libseccomp wget socat git httpd-tools nc

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
cat > kubernetes.conf <<EOF
net.bridge.bridge-nf-call-iptables=1
net.bridge.bridge-nf-call-ip6tables=1
net.ipv4.ip_forward=1
net.ipv4.tcp_tw_recycle=0
net.ipv4.neigh.default.gc_thresh1=1024
net.ipv4.neigh.default.gc_thresh2=2048
net.ipv4.neigh.default.gc_thresh3=4096
vm.swappiness=0
vm.overcommit_memory=1
vm.panic_on_oom=0
fs.inotify.max_user_instances=8192
fs.inotify.max_user_watches=1048576
fs.file-max=52706963
fs.nr_open=52706963
net.ipv6.conf.all.disable_ipv6=1
net.netfilter.nf_conntrack_max=2310720
EOF
cp kubernetes.conf  /etc/sysctl.d/kubernetes.conf
sysctl -p /etc/sysctl.d/kubernetes.conf
