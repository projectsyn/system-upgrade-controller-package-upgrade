#!/bin/bash

# curl -sfL https://get.k3s.io | sh -s - server --cluster-init --token=mynodetoken --node-external-ip 192.168.216.11 --node-ip 192.168.216.11 --flannel-iface enp0s8
curl -sfL https://get.k3s.io | sh -s - server --token=mynodetoken --node-external-ip 192.168.216.11 --node-ip 192.168.216.11 --flannel-iface enp0s8
curl -s "https://raw.githubusercontent.com/\
kubernetes-sigs/kustomize/master/hack/install_kustomize.sh"  | bash
mv kustomize /usr/local/bin
kustomize build https://github.com/rancher/system-upgrade-controller | kubectl apply -f -
# kubectl label node agent1 plan.upgrade.cattle.io/bionic=true
rm -rf /var/lib/apt/lists/*
sudo snap install helm --classic
export KUBECONFIG=/etc/rancher/k3s/k3s.yaml
helm repo add stable https://kubernetes-charts.storage.googleapis.com
helm install stable/prometheus --generate-name
helm install stable/grafana --generate-name


# second agent

# curl -sfL https://get.k3s.io | sh -s - server --server https://192.168.216.11:6443 --token=mynodetoken --node-external-ip 192.168.216.12 --node-ip 192.168.216.12 --flannel-iface enp0s8 --kubelet-arg node-labels=node-role.kubernetes.io/worker=worker
curl -sfL https://get.k3s.io | K3S_URL=https://192.168.216.11:6443 sh -s - agent --token=mynodetoken --node-external-ip "$(ip --brief addr | grep 216 | tr -s ' ' | cut -d ' ' -f 3 | cut -d '/' -f 1)" --node-ip "$(ip --brief addr | grep 216 | tr -s ' ' | cut -d ' ' -f 3 | cut -d '/' -f 1)" --flannel-iface enp0s8
kubectl label node "$(hostname)" plan.upgrade.cattle.io/bionic=true
