#!/bin/bash

set -o allexport
source .env
set +o allexport

echo "CONFIGURE_ARGOCD: Setting kubectl context"
sudo kubectl config set-context --current --namespace=argocd
echo "CONFIGURE_ARGOCD: Setting password"
DEFAULT_PASSWORD=$(sudo argocd admin initial-password -n argocd)
DEFAULT_PASSWORD=${DEFAULT_PASSWORD%%$'\n'*}
sudo argocd login $ARGOCD_SERVER \
		--username admin \
		--password "$DEFAULT_PASSWORD" \
		--insecure

sudo argocd account update-password \
		--current-password "$DEFAULT_PASSWORD" \
		--new-password "$ARGOCD_PASSWORD"

# echo "CONFIGURE_ARGOCD: Adding app repo"
# sudo argocd repo add git@github.com:itsfwenk/IoT-p3.git \
# 	--ssh-private-key-path ~/.ssh/id_rsa
# sudo argocd repo list

echo "CONFIGURE_ARGOCD: Creating app"
sudo argocd app create wilapp \
       	--repo https://github.com/itsfwenk/IoT-p3.git \
       	--path ./p3-manifests \
		--dest-server https://kubernetes.default.svc \
       	--dest-namespace dev \
		--sync-policy automated \
  		--auto-prune \
  		--self-heal

sudo argocd app set wilapp --sync-policy automated
sudo argocd app set wilapp --self-heal

echo "CONFIGURE_ARGOCD: Done"
echo "$DEFAULT_PASSWORD"

