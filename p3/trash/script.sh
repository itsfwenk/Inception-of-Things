#!/bin/bash
set -e # Exit immediately if a command exits with a non-zero status

echo "--- Starting VM setup script ---"

# --- 1. Update package list ---
echo "Updating apt package list..."
sudo apt update

# --- 2. Install necessary dependencies for Docker and others ---
echo "Installing common dependencies..."
sudo apt install -y apt-transport-https ca-certificates curl gnupg lsb-release git

# --- 3. Install Docker ---
if ! command -v docker &> /dev/null; then
    echo "Docker not found. Installing Docker..."
    # Add Docker's official GPG key:
    sudo install -m 0755 -d /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    sudo chmod a+r /etc/apt/keyrings/docker.gpg

    # Add the Docker repository to Apt sources:
    echo \
      "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
      "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
      sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt update

    # Install Docker Engine
    sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

    # Add current user to the docker group (IMPORTANT for k3d to work without sudo)
    echo "Adding current user ($USER) to the docker group..."
    sudo usermod -aG docker $USER
    echo "Please log out and log back in, or run 'newgrp docker' for Docker permissions to take effect."
    # This part requires manual intervention or a shell restart, so advise the user.
else
    echo "Docker is already installed."
fi

# --- 4. Install k3d ---
if ! command -v k3d &> /dev/null; then
    echo "k3d not found. Installing k3d..."
    # You can specify a version here if needed, e.g., export K3D_VERSION="v5.6.0"
    curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash
else
    echo "k3d is already installed."
fi

# --- 5. Install kubectl ---
if ! command -v kubectl &> /dev/null; then
    echo "kubectl not found. Installing kubectl..."
    KUBECTL_VERSION=$(curl -L -s https://dl.k8s.io/release/stable.txt)
    curl -LO "https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl"
    chmod +x kubectl
    sudo mv kubectl /usr/local/bin/
else
    echo "kubectl is already installed."
fi

echo "--- VM setup script finished ---"
echo "Remember to re-login or run 'newgrp docker' to apply Docker group changes."













# Install argo cd cli (if not already done in setup script)
# curl -sSL https://raw.githubusercontent.com/argoproj/argo-cd/stable/install.sh | sudo bash
# Login to Argo CD CLI
# argocd login localhost:8080 # if port-forwarding
# argocd login <argocd-server-ip> # if exposed differently
# argocd account enable-admin # if you want to set a new password
# argocd app create my-app \
#   --repo https://github.com/your-username/my-gitops-app.git \
#   --path k8s-manifests \
#   --dest-server https://kubernetes.default.svc \
#   --dest-namespace dev \
#   --sync-policy automated \
#   --auto-prune \
#   --self-heal