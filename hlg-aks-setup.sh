#!/bin/bash 

cd kustomize/ingress/hlg/ && az aks command invoke --resource-group rg-hlg-aks  --name aks-hlg-tbd-eastus2-01 --command "kubectl apply -f ." --file . && az aks command invoke --resource-group rg-hlg-aks --name aks-hlg-tbd-eastus2-01 --command