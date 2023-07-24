#!/usr/bin/env bash 

# az vmss run-command invoke -g aks-hlg-tbd-eastus2-01-nrg -n aks-aksdnpjxg-24333267-vmss --command-id RunShellScript \
#     --instance-id /subscriptions/f08b1fe3-f4f7-4c0a-bb51-d6a47cf1a81c/resourceGroups/aks-hlg-tbd-eastus2-01-nrg/providers/Microsoft.Compute/virtualMachineScaleSets/aks-aksdnpjxg-24333267-vmss \
#     --scripts "nslookup aks-hlg-tbd-eastus2-01.privatelink.eastus2.azmk8s.io."

az aks update --resource-group rg-hlg-aks --name aks-hlg-tbd-eastus2-01 
az aks nodepool update \
    --resource-group rg-hlg-aks \
    --cluster-name aks-hlg-tbd-eastus2-01 \
    --name aks-aksdnpjxg-24333267-vmss
