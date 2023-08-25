#!/bin/bash 

kubectl patch deployment "ingress-nginx-controller" -n "ingress-nginx" --type "json" --patch '[{"op":"add","path":"/spec/template/spec/containers/0/args/-","value":"--default-ssl-certificate=ingress-nginx/terra-app-tls"}]'



