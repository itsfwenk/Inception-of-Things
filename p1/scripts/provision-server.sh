#!/bin/bash

K3S_TOKEN_FILE_PATH=$1

echo "  > Installing K3s server from stable channel..."

curl -sfL https://get.k3s.io | sh -s - --write-kubeconfig-mode 644 \
    --cluster-init \
    --token "TOKEN"

echo "  > K3s installation command executed."

echo "  > Waiting for Kubeconfig to be ready..."
timeout 120 sh -c 'while [ ! -f /etc/rancher/k3s/k3s.yaml ]; do sleep 2; done'
if [ ! -f /etc/rancher/k3s/k3s.yaml ]; then
    echo "ERROR: Kubeconfig file not found after timeout. K3s might not have started correctly."
    exit 1
fi

sudo cat /var/lib/rancher/k3s/server/node-token > "${K3S_TOKEN_FILE_PATH}"
sudo chmod 644 "${K3S_TOKEN_FILE_PATH}"