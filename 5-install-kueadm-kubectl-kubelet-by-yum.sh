#!/bin/bash
yum install -y kubeadm-1.20.5 kubectl-1.20.5 kubelet-1.20.5 --disableexcludes=kubernetes
systemctl enable --now kubelet
