#!/bin/bash
bash -c "echo net.ipv4.ip_forward=1 >> /etc/sysctl.conf"
sysctl -p /etc/sysctl.conf


curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/install.sh)"


## Install Kubernetes CLI
curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl
