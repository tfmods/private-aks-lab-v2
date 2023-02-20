#!/bin/bash

lb_ip="10.100.1.8"
kubectl create ns nginx-ingress
helm install nginx-ingress nginx-stable/nginx-ingress -n nginx-ingress

cat <<EOF>> nginx-private.yaml
controller:
  service: $lb_ip
    loadBalancerIP: 
    annotations:
      service.beta.kubernetes.io/azure-load-balancer-internal: "true"
EOF

helm upgrade nginx-ingress nginx-stable/nginx-ingress -f ./nginx-private.yaml 