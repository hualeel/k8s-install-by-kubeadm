kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
# 查看Pod信息
kubectl --namespace=kube-system get pod
