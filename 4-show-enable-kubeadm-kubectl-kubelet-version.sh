#!/bin/bash
yum list --showduplicates | grep 'kubeadm\|kubectl\|kubelet'
