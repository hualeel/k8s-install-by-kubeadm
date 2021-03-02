#!/bin/bash
yum install -y kubeadm-1.19.8 kubectl-1.19.8 kubelet-1.19.8 --disableexcludes=kubernetes
systemctl enable --now kubelet
