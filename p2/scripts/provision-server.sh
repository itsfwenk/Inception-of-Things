#!/bin/bash

echo "  > Installing K3s server from stable channel..."

curl -sfL https://get.k3s.io | sh -s - --write-kubeconfig-mode 644 \
    --tls-san 192.168.56.110

echo "  > K3s installation command executed."

echo "  > Waiting for Kubeconfig to be ready..."
timeout 120 sh -c 'while [ ! -f /etc/rancher/k3s/k3s.yaml ]; do sleep 2; done'
if [ ! -f /etc/rancher/k3s/k3s.yaml ]; then
    echo "ERROR: Kubeconfig file not found after timeout. K3s might not have started correctly."
    exit 1
fi

echo "  > Copying Kubeconfig to /home/vagrant/.kube/config..."
mkdir -p /home/vagrant/.kube
cp /etc/rancher/k3s/k3s.yaml /home/vagrant/.kube/config
chown -R vagrant:vagrant /home/vagrant/.kube
chmod 600 /home/vagrant/.kube/config

kubectl apply -f /vagrant_manifests/