#!/bin/bash

# Exit immediately if a command exits with a non-zero status.
set -e

# Arguments: K3S_SERVER_IP, K3S_VERSION
K3S_SERVER_IP=$1
K3S_VERSION=$2
SHARED_DATA_DIR="/vagrant_data" # This path is mounted from Vagrantfile
K3S_TOKEN_FILE="${SHARED_DATA_DIR}/k3s_token"
WORKER_IP="192.168.56.111" # Hardcode or pass as arg if more dynamic

echo "--- Provisioning K3s Worker (${K3S_VERSION}) on ${WORKER_IP} ---"

# 1. Wait for the K3s token to be available from the server
echo "  > Waiting for K3s token from server (${K3S_TOKEN_FILE})..."
# Loop until the token file exists in the shared directory
until [ -f "${K3S_TOKEN_FILE}" ]; do
  printf '.' # Print a dot to show progress
  sleep 5    # Wait 5 seconds before checking again
done
echo ""
echo "  > K3s token found."

# Read the K3s token from the file
K3S_TOKEN=$(cat "${K3S_TOKEN_FILE}")

# 2. Install K3s as an agent
if ! command -v k3s &> /dev/null; then
    echo "  > Installing K3s agent..."
    # K3S_URL: Specifies the server's API endpoint.
    # K3S_TOKEN: Provides the shared secret for the agent to join the cluster.
    # --node-ip: Specifies the IP address of this worker node.
    # --flannel-iface: Ensures Flannel uses the private network interface.
    INSTALL_K3S_VERSION="${K3S_VERSION}" K3S_URL="https://${K3S_SERVER_IP}:6443" K3S_TOKEN="${K3S_TOKEN}" curl -sfL https://get.k3s.io | sh -s - agent \
        --node-ip "${WORKER_IP}" \
        --flannel-iface "eth1"
    echo "  > K3s agent installation initiated."
else
    echo "  > K3s agent already installed."
fi

echo "--- K3s Worker provisioning complete ---"