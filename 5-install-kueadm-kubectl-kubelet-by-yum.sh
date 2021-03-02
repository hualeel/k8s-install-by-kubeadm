#!/bin/bash
yum install -y kubeadm-1.19.4 kubectl-1.19.4 kubelet-1.19.4 --disableexcludes=kubernetes
systemctl enable --now kubelet
