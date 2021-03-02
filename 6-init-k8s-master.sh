#!/bin/bash
kubeadm init \
--apiserver-advertise-address=192.168.0.68 \
--image-repository=registry.aliyuncs.com/google_containers \
--kubernetes-version=v1.19.4 \
--service-cidr=10.96.0.0/12 \
--pod-network-cidr=10.244.0.0/16
