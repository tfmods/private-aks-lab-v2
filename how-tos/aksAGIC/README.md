# Step by step

```
export app_gw_rg=rg-network-tbd-eastus2-01
export aks_name=aks-dev-tbd-eastus2-01
export pip_name=dev-tbd-appgw-pip-eastus2-01
export appgw_vnet_name=vn-tbd-eastus2
export appgw_snet_name=AppGw
export location=eastus2
export appgw_name=dev-appgw-tbd-eastus2-01
export waf_policy_name=dev-waf-policy-tbd-eastus2-01
export aks_rg_name=rg-dsv-aks


```

```
# Create public ip
az network public-ip create -n $pip_name -g $app_gw_rg -l $location --allocation-method Static --sku Standard
```

```
# Create vnet
az network vnet create -n $appgwVnetName -g $app_gw_rg -l $location --address-prefix 10.0.0.0/16 --subnet-name $appgwSnetName --subnet-prefix 10.0.0.0/24
```

```
# Create WAF policy
az network application-gateway waf-policy create --name $waf_policy_name --resource-group $app_gw_rg
```

```
# Create application gateway
az network application-gateway create -n $appgw_name -l $location -g $app_gw_rg --sku WAF_v2 --public-ip-address $pip_name --vnet-name $appgw_vnet_name --subnet $appgw_snet_name --priority 100 --waf-policy $waf_policy_name
```

```
# Enable Application Gateway Ingress Controller on AKS
appgwId=$(az network application-gateway show -n $appgw_name -g $app_gw_rg -o tsv --query "id")
az aks enable-addons -n $aksName -g $app_gw_rg -a ingress-appgw --appgw-id $appgwId
```

```
# Create vnet peerings
aksVnetId=$(az network vnet show -n $aksVnetName -g $app_gw_rg -o tsv --query "id")
az network vnet peering create -n AppGWtoAKSVnetPeering -g $app_gw_rg --vnet-name $appgwVnetName --remote-vnet $aksVnetId --allow-vnet-access

appGWVnetId=$(az network vnet show -n $appgwVnetName -g $app_gw_rg -o tsv --query "id")
az network vnet peering create -n AKStoAppGWVnetPeering -g $app_gw_rg --vnet-name $aksVnetName --remote-vnet $appGWVnetId --allow-vnet-access
```

```
# Let's deploy a simple webserver application
git clone https://github.com/soaand01/aksAGIC.git
cd deployments
kubectl create namespace nginx
kubectl apply -f nginx-deployment.yaml -n nginx
kubectl apply -f nginx-service.yaml -n nginx
kubectl apply -f nginx-ingress.yaml -n nginx
```

```
# Getting your Ingress IP
kubectl get ingress -n nginx
```