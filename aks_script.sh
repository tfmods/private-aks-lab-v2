#!/bin/bash
KUBE_NAME=aks-dev-tbd-eastus2-01
KUBE_GROUP=rg-dsv-aks


MSI_RESOURCE_ID=$(az identity show -n aks-dev-tbd-eastus2-01 -g rg-dsv-aks -o json | jq -r ".id")

MSI_CLIENT_ID=$(az identity show -n $KUBE_NAME -g $KUBE_GROUP -o json | jq -r ".clientId")

echo $MSI_CLIENT_ID

echo $MSI_RESOURCE_ID
