#!/bin/bash

set -e

K3S_VERSION=$1
KUBECONFIG_DIR="/home/vagrant/.kube"
KUBECONFIG_FILE="${KUBECONFIG_DIR}/config"
SHARED_DATA_DIR="/vagrant_data"
K3S_TOKEN_FILE="${SHARED_DATA_DIR}/k3s_token"
SERVER_IP="192.168.56.110"

echo "--- Provisioning K3s Server (${K3S_VERSION}) on ${SERVER_IP} ---"

if ! command -v k3s &> /dev/null; then
    echo "  > Installing K3s server..."
    INSTALL_K3S_VERSION="${K3S_VERSION}" curl -sfL https://get.k3s.io | sh -s - server \
        --write-kubeconfig-mode "644" \
        --bind-address "${SERVER_IP}" \
        --flannel-iface "eth1"
    echo "  > K3s server installation initiated. Waiting for readiness..."
    until sudo systemctl is-active k3s &> /dev/null; do
      printf '.'
      sleep 2
    done
    echo ""
    echo "  > K3s server is active."
else
    echo "  > K3s server already installed."
fi

if ! command -v kubectl &> /dev/null; then
    echo "  > Installing kubectl..."
    sudo apt-get update -qq > /dev/null
    sudo apt-get install -y apt-transport-https ca-certificates curl gnupg > /dev/null

    curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.28/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
    echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.28/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list > /dev/null

    sudo apt-get update -qq > /dev/null
    sudo apt-get install -y kubectl > /dev/null
else
    echo "  > kubectl already installed."
fi

echo "  > Configuring kubectl for vagrant user..."
sudo mkdir -p "${KUBECONFIG_DIR}"
sudo cp /etc/rancher/k3s/k3s.yaml "${KUBECONFIG_FILE}"
sudo chown -R vagrant:vagrant "${KUBECONFIG_DIR}"
chmod 600 "${KUBECONFIG_FILE}"

echo "export KUBECONFIG=${KUBECONFIG_FILE}" >> /home/vagrant/.bashrc
echo "export KUBECONFIG=${KUBECONFIG_FILE}" >> /home/vagrant/.profile

echo "  > Retrieving K3s token and saving to shared folder..."
sudo mkdir -p "${SHARED_DATA_DIR}"
sudo cat /var/lib/rancher/k3s/server/node-token > "${K3S_TOKEN_FILE}"
sudo chown vagrant:vagrant "${K3S_TOKEN_FILE}"
sudo chmod 600 "${K3S_TOKEN_FILE}"

echo "--- K3s Server provisioning complete ---"
echo "K3s token saved to ${K3S_TOKEN_FILE}"