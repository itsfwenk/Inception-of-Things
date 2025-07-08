#!/bin/bash

DOCKER_VERSION=$(docker --version 2>/dev/null)
K3D_VERSION=$(k3d version 2>/dev/null)
KUBECTL_VERSION=$(kubectl version 2>/dev/null)

set -euo pipefail 

if [[ -z $DOCKER_VERSION ]]; then
	echo "INSTALL_K3D: Installing Docker..."
	echo "INSTALL_K3D: Removing conflicting packages..."
	for pkg in docker.io docker-doc docker-compose podman-docker containerd runc; do sudo apt-get remove $pkg; done
	echo "INSTALL_K3D: Setting up Docker's apt repos..."
	sudo apt-get update -y
	sudo apt-get install ca-certificates curl -y
	sudo install -m 0755 -d /etc/apt/keyrings
	sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
	sudo chmod a+r /etc/apt/keyrings/docker.asc
	echo \
		"deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
		$(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
	sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
	sudo apt-get update -y
	echo "INSTALL_K3D: Installing Docker package..."
	sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
	echo "INSTALL_K3D: Testing Docker install..."
	sudo docker run hello-world
else
	echo "INSTALL_K3D: Docker already installed"
fi

if [[ -z $KUBECTL_VERSION ]]; then
	echo "INSTALL_K3D: Downloading kubectl..."
	curl -LO  "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
	echo "INSTALL_K3D: Downloading kubectl checksum..."
	curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256"
	echo "INSTALL_K3D: Validating kubectl install file"
	echo "$(cat kubectl.sha256)  kubectl" | sha256sum --check
	echo "INSTALL_K3D: Installing kubectl..."
	sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
	echo "INSTALL_K3D: Installing kubectl install"
	kubectl version --client
else
	echo "INSTALL_K3D: Kubectl already installed"
fi

if [[ -n $K3D_VERSION ]]; then
	echo "INSTALL_K3D: K3D already installed."
	exit 0
fi

echo "INSTALL_K3D: Cleaning up"
rm -f kubectl
rm -f kubectl.sha256

echo "INSTALL_K3D: Installing k3d..."
curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash
echo "INSTALL_K3D: Done!"