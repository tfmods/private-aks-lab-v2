#!/bin/bash
az aks command invoke --resource-group rg-hlg-aks --name aks-hlg-tbd-eastus2-01 --command "$1"
