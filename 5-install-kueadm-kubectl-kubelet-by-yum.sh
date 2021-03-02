yum install -y kubeadm-1.20.4 kubectl-1.20.4 kubelet-1.20.4 --disableexcludes=kubernetes
systemctl enable --now kubelet
