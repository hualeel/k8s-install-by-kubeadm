# 安装依赖抱
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
sed -ri 's/SELINUX=enforcing/SELINUX=disabled/' /etc/selinux/config
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
echo 'vm.max_map_count=262144' >> /etc/sysctl.conf
echo 'net.ipv4.ip_forward = 1' >> /etc/sysctl.conf
echo 'vm.drop_caches=3' >> /etc/sysctl.conf
sysctl -p
ulimit -c 0 && echo 'ulimit -S -c 0' >>/etc/profile
modprobe iptable_nat
