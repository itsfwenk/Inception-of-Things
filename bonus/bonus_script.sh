# k3d cluster delete [cluster name]

# Create a new cluster, mapping host ports to the load balancer (Traefik)
# 80:80@loadbalancer -> Host port 80 to cluster's Ingress on port 80 (HTTP)
# 443:443@loadbalancer -> Host port 443 to cluster's Ingress on port 443 (HTTPS)
# 2222:22@loadbalancer -> Host port 2222 to cluster's SSH service on port 22 (for GitLab SSH)

# k3d cluster create bonus-cluster --servers 1 --agents 1 \
#   -p "80:80@loadbalancer" \
#   -p "443:443@loadbalancer" \
#   -p "2222:22@loadbalancer" \
#   --kubeconfig-update-default=true --kubeconfig-switch-context=true

k3d cluster create my-k3s-cluster --servers 1 --agents 1 \
  -p "80:80@loadbalancer" \
  -p "443:443@loadbalancer" \
  -p "2222:22@loadbalancer" \
  --kubeconfig-update-default=true --kubeconfig-switch-context=true \
  --k3s-arg "--disable-helm-controller@server:0" \
  --k3s-arg "--disable=traefik@server:0" # <--- IMPORTANT: Disable Traefik

# Verify cluster status
kubectl get nodes

kubectl create namespace gitlab

kubectl get storageclass
# You should see 'local-path (default)' or similar.

helm repo add gitlab https://charts.gitlab.io/
helm repo update

helm install gitlab gitlab/gitlab -n gitlab -f ./helm/gitlab/gitlab-values.yaml --timeout 600s