#!/bin/bash

K3S_SERVER_IP=$1
K3S_AGENT_NODE_IP=$2
K3S_TOKEN_FILE_PATH=$3

# export INSTALL_K3S_EXEC="agent --server https://$1:6443 --token-file ${K3S_TOKEN_FILE_PATH} --node-ip=$2"

timeout 180 sh -c 'while [ ! -f "${K3S_TOKEN_FILE_PATH}" ]; do sleep 5; done'
if [ ! -f "${K3S_TOKEN_FILE_PATH}" ]; then
    echo "ERROR: K3s token file not found at ${K3S_TOKEN_FILE_PATH} after timeout."
    echo "Ensure the server VM successfully provisioned and saved the token."
    exit 1
fi
echo "  > K3s token file found."
K3S_TOKEN=$(cat "${K3S_TOKEN_FILE_PATH}")

curl -sfL https://get.k3s.io | sh -s - agent \
    --server https://${K3S_SERVER_IP}:6443 \
    --node-ip="${K3S_AGENT_NODE_IP}" \
    --token "${K3S_TOKEN}"

echo "  > K3s worker installation command executed."

echo "  > K3s worker should be running and connected to the server."

echo "  > Deleting token at ${K3S_TOKEN_FILE_PATH}."
rm -rf ${K3S_TOKEN_FILE_PATH}