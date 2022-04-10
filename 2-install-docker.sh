#!/bin/bash
cat > /etc/yum.repos.d/docker-ce.repo <<-EOF
[docker-ce-stable]
name=Docker CE Stable Mirror Repository
baseurl=https://mirrors.aliyun.com/docker-ce/linux/centos/7/x86_64/stable
enabled=0
gpgcheck=1
gpgkey=https://mirrors.aliyun.com/docker-ce/linux/centos/gpg
EOF
yum install --enablerepo=docker-ce-stable -y docker-ce
# 配置加速器
# 使用 systemd 管理容器 cgroup
cat > /etc/docker/daemon.json <<-EOF
{
    "registry-mirrors": [
        "https://registry.docker-cn.com",
        "https://registry.cn-hangzhou.aliyuncs.com"
    ],
    "exec-opts": ["native.cgroupdriver=systemd"],
    "log-driver": "json-file",
    "log-opts": {"max-size": "100m"},
    "storage-driver": "overlay2"
}
EOF
systemctl enable docker
systemctl daemon-reload
systemctl start docker
