# Inception-of-Things (IoT)

A comprehensive DevOps and Kubernetes learning project that demonstrates container orchestration, infrastructure as code, and GitOps principles through practical hands-on exercises.

## 📋 Table of Contents

- [Overview](#overview)
- [Project Structure](#project-structure)
- [Prerequisites](#prerequisites)
- [Part 1: K3s and Vagrant](#part-1-k3s-and-vagrant)
- [Part 2: K3s and Applications](#part-2-k3s-and-applications)
- [Part 3: K3d and Argo CD](#part-3-k3d-and-argo-cd)
- [Bonus: GitLab with Helm](#bonus-gitlab-with-helm)
- [Getting Started](#getting-started)
- [Technologies Used](#technologies-used)
- [Learning Objectives](#learning-objectives)

## 🎯 Overview

Inception-of-Things is a hands-on project designed to teach essential DevOps and Kubernetes concepts through progressive exercises. Each part builds upon the previous one, introducing new tools and concepts while reinforcing fundamental skills.

The project covers:
- **Infrastructure as Code** with Vagrant
- **Container Orchestration** with K3s/K3d
- **Application Deployment** with Kubernetes manifests
- **GitOps** with Argo CD
- **Package Management** with Helm
- **CI/CD** with GitLab

## 📁 Project Structure

```
iot/
├── p1/                     # Part 1: K3s Cluster with Vagrant
│   ├── Vagrantfile         # VM configuration (server + worker)
│   └── scripts/
│       ├── provision-server.sh   # K3s server setup
│       └── provision-worker.sh   # K3s worker setup
├── p2/                     # Part 2: K3s with Applications
│   ├── Vagrantfile         # Single VM configuration
│   ├── confs/              # Kubernetes manifests
│   │   ├── app1-*.yaml     # App1 (nginx) configuration
│   │   ├── app2-*.yaml     # App2 (nginx) configuration
│   │   ├── app3-*.yaml     # App3 (nginx) configuration
│   │   └── ingress.yaml    # Ingress controller configuration
│   └── scripts/
│       └── provision-server.sh
├── p3/                     # Part 3: K3d with Argo CD
│   ├── confs/
│   │   ├── configure_k3d.sh      # K3d cluster setup
│   │   └── configure_argocd.sh   # Argo CD configuration
│   └── scripts/
│       └── install_k3d.sh        # K3d installation
└── bonus/                  # Bonus: GitLab with Helm
    ├── bonus_script.sh     # K3d cluster creation
    └── helm/
        └── gitlab/
            └── gitlab-values.yaml  # GitLab Helm values
```

## 🔧 Prerequisites

Before starting this project, ensure you have the following installed:

- **VirtualBox** (6.1 or later)
- **Vagrant** (2.2 or later)
- **Docker** (20.10 or later)
- **kubectl** (latest stable version)
- **k3d** (5.0 or later)
- **Helm** (3.0 or later)

### System Requirements

- **RAM**: Minimum 8GB (16GB recommended)
- **Storage**: At least 20GB free space
- **OS**: Linux, macOS, or Windows with WSL2

## 🚀 Part 1: K3s and Vagrant

**Objective**: Set up a K3s cluster using Vagrant with one server and one worker node.

### Features
- Automated K3s server and worker node deployment
- Private network configuration (192.168.56.0/24)
- Shared storage between VMs
- Token-based node authentication

### Usage
```bash
cd p1/
vagrant up
vagrant ssh fliS  # Connect to server node
vagrant ssh fliSW # Connect to worker node
```

### Architecture
- **Server Node** (`fliS`): 192.168.56.110 - K3s control plane
- **Worker Node** (`fliSW`): 192.168.56.111 - K3s worker node

## 🌐 Part 2: K3s and Applications

**Objective**: Deploy multiple applications on K3s with ingress routing.

### Features
- Single-node K3s cluster
- Three different nginx applications
- Ingress controller for HTTP routing
- ConfigMaps for application content
- Service exposure and load balancing

### Applications
- **App1**: Available at `app1.com`
- **App2**: Available at `app2.com`
- **App3**: Available at `app3.com`

### Usage
```bash
cd p2/
vagrant up
# Add entries to /etc/hosts:
# 192.168.56.110 app1.com app2.com app3.com
```

## ⚡ Part 3: K3d and Argo CD

**Objective**: Implement GitOps using K3d and Argo CD for automated deployments.

### Features
- K3d cluster (lightweight K3s in Docker)
- Argo CD for GitOps workflows
- Automated application deployment
- Declarative configuration management

### Usage
```bash
cd p3/
./confs/configure_k3d.sh
# Access Argo CD at localhost:8080
```

### Key Components
- **K3d**: Containerized K3s cluster
- **Argo CD**: GitOps continuous delivery tool
- **Port Forwarding**: Access services locally

## 🎁 Bonus: GitLab with Helm

**Objective**: Deploy a complete GitLab instance using Helm charts.

### Features
- GitLab CE deployment with Helm
- Integrated CI/CD pipelines
- Container registry
- MinIO for object storage
- Traefik ingress controller

### Usage
```bash
cd bonus/
./bonus_script.sh
helm install gitlab gitlab/gitlab -f helm/gitlab/gitlab-values.yaml
# Access GitLab at gitlab.local
```

## 🏃‍♂️ Getting Started

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd iot
   ```

2. **Start with Part 1**
   ```bash
   cd p1/
   vagrant up
   ```

3. **Verify the setup**
   ```bash
   vagrant ssh fliS
   sudo kubectl get nodes
   ```

4. **Progress through each part sequentially**

## 🛠 Technologies Used

| Technology | Purpose | Part |
|------------|---------|------|
| **Vagrant** | VM management and provisioning | P1, P2 |
| **K3s** | Lightweight Kubernetes distribution | P1, P2 |
| **K3d** | K3s in Docker containers | P3, Bonus |
| **Docker** | Container runtime | All |
| **Kubernetes** | Container orchestration | All |
| **Argo CD** | GitOps continuous delivery | P3 |
| **Helm** | Kubernetes package manager | Bonus |
| **GitLab** | CI/CD and Git repository | Bonus |
| **Nginx** | Web server and reverse proxy | P2 |
| **Traefik** | Ingress controller | P2, Bonus |

## 📚 Learning Objectives

By completing this project, you will learn:

### Infrastructure & Orchestration
- ✅ Setting up Kubernetes clusters with K3s/K3d
- ✅ Managing virtual machines with Vagrant
- ✅ Container orchestration principles
- ✅ Network configuration and service discovery

### Application Deployment
- ✅ Writing Kubernetes manifests (Deployments, Services, ConfigMaps)
- ✅ Configuring ingress controllers and routing
- ✅ Managing application lifecycle
- ✅ Resource management and scaling

### DevOps Practices
- ✅ Infrastructure as Code (IaC)
- ✅ GitOps workflows with Argo CD
- ✅ Package management with Helm
- ✅ CI/CD pipeline setup with GitLab

### Monitoring & Troubleshooting
- ✅ Debugging Kubernetes deployments
- ✅ Log analysis and monitoring
- ✅ Performance optimization
- ✅ Security best practices

## 🔍 Troubleshooting

### Common Issues

**VirtualBox Issues**
```bash
# Enable virtualization in BIOS
# Check VirtualBox version compatibility
vagrant plugin install vagrant-vbguest
```

**K3s Installation Problems**
```bash
# Check system resources
# Verify network connectivity
sudo systemctl status k3s
```

**kubectl Access Issues**
```bash
# Copy kubeconfig
sudo cp /etc/rancher/k3s/k3s.yaml ~/.kube/config
sudo chown $USER:$USER ~/.kube/config
```

## 📖 Additional Resources

- [K3s Documentation](https://k3s.io/)
- [K3d Documentation](https://k3d.io/)
- [Argo CD Documentation](https://argo-cd.readthedocs.io/)
- [Helm Documentation](https://helm.sh/docs/)
- [Kubernetes Documentation](https://kubernetes.io/docs/)

## 🤝 Contributing

This is a learning project. Feel free to:
- Report issues
- Suggest improvements
- Share alternative approaches
- Add documentation

## 📄 License

This project is for educational purposes. Please respect the licenses of the individual tools and technologies used.

---

**Happy Learning! 🎉**

*Master the art of container orchestration and DevOps with hands-on experience.*
