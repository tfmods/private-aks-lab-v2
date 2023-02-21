#!/bin/bash

lb_ip="10.100.1.8"

# Cria Namespace para o Ingress Controller
kubectl create ns nginx-ingress

# Instala o Helm chart do nginx
helm repo add nginx-stable https://helm.nginx.com/stable

helm repo update


# Instala o Chart no cluster
helm install nginx-ingress nginx-stable/nginx-ingress -n nginx-ingress


#Criando arquivo de patch para utilização de um loadbalancer privado

cat <<EOF>> nginx-private.yaml
controller:
  service:
    loadBalancerIP: 
    annotations:
      service.beta.kubernetes.io/azure-load-balancer-internal: "true"
EOF

# Fazendo Update do Chart
helm upgrade nginx-ingress nginx-stable/nginx-ingress -f ./nginx-private.yaml -n nginx-ingress