#!/bin/bash
kubeadm init \
--apiserver-advertise-address=192.168.0.68 \
--image-repository=registry.aliyuncs.com/google_containers \
--kubernetes-version=v1.20.5 \
--service-cidr=10.3.0.0/16 \
--pod-network-cidr=10.4.0.0/16
