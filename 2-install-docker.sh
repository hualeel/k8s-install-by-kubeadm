cat > /etc/yum.repos.d/docker-ce.repo <<EOF
[docker-ce-stable]
name=Docker CE Stable Mirror Repository
baseurl=https://mirrors.aliyun.com/docker-ce/linux/centos/7/x86_64/stable
enabled=0
gpgcheck=1
gpgkey=https://mirrors.aliyun.com/docker-ce/linux/centos/gpg
EOF
 
yum install --enablerepo=docker-ce-stable -y docker-ce-18.06.1.ce
 
# 配置加速器
cat > /etc/docker/daemon.json <<-EOF
{
    "registry-mirrors": [
        "https://registry.docker-cn.com",
        "https://registry.cn-hangzhou.aliyuncs.com"
    ],
    "exec-opts": [
        "native.cgroupdriver=systemd"
    ]
}
EOF

systemctl daemon-reload
systemctl enable docker
systemctl start docker
