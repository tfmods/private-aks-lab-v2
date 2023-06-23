# Deploy do agic em redes dferentes

# Export your variables
export rgName=rg-network-tbd-eastus2-01
export aksName=aks-dev-tbd-eastus2-01
export pipName=dev-tbd-eastus2-01-agic-pip
export appgwVnetName=vn-tbd-eastus2
export appgwSnetName=AppGw
export location=eastus2
export appgwName=dev-AppGw-tbd-eastus2-01
export wafPolicyName=dev-waf-policy-tbd-eastus2-01
export aksVnetName=vn-tbd-eastus2
export aksrgName=rg-dsv-aks

# Create public ip
az network public-ip create -n $pipName -g $rgName -l $location --allocation-method Static --sku Standard

# Create vnet
<!-- az network vnet create -n $appgwVnetName -g $rgName -l $location --address-prefix 10.0.0.0/16 --subnet-name $appgwSnetName --subnet-prefix 10.0.0.0/24 -->

# Create WAF policy
az network application-gateway waf-policy create --name $wafPolicyName --resource-group $rgName

# Create application gateway
az network application-gateway create -n $appgwName -l westeurope -g $rgName --sku WAF_v2 --public-ip-address $pipName --vnet-name $appgwVnetName --subnet $appgwSnetName --priority 100 --waf-policy $wafPolicyName

# Enable Application Gateway Ingress Controller on AKS
appgwId=$(az network application-gateway show -n $appgwName -g $rgName -o tsv --query "id")
az aks enable-addons -n $aksName -g $aksrgName -a ingress-appgw --appgw-id $appgwId

<!-- # Create vnet peerings
aksVnetId=$(az network vnet show -n $aksVnetName -g $rgName -o tsv --query "id")
az network vnet peering create -n AppGWtoAKSVnetPeering -g $rgName --vnet-name $appgwVnetName --remote-vnet $aksVnetId --allow-vnet-access -->

<!-- appGWVnetId=$(az network vnet show -n $appgwVnetName -g $rgName -o tsv --query "id")
az network vnet peering create -n AKStoAppGWVnetPeering -g $rgName --vnet-name $aksVnetName --remote-vnet $appGWVnetId --allow-vnet-access -->

# Let's deploy a simple webserver application
cd deployments
kubectl create namespace nginx
kubectl apply -f nginx-deployment.yaml -n nginx
kubectl apply -f nginx-service.yaml -n nginx
kubectl apply -f nginx-ingress.yaml -n nginx


# Getting your Ingress IP
kubectl get ingress -n ng