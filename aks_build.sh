AKS_RG="rg-hlg-aks"
AKS_ID_RG="rg-dsv-aks"
DNS_RG="rg-network-tss-eastus2-01"
DNS_ID="/subscriptions/2d4a11ab-535f-464e-9bed-fad7b59415bf/resourceGroups/rg-network-tss-eastus2-01/providers/Microsoft.Network/privateDnsZones/privatelink.eastus2.azmk8s.io"
AKS_NAME=aks-hlg-tbd-eastus2-01
DNS_ZONE_NAME="/subscriptions/2d4a11ab-535f-464e-9bed-fad7b59415bf/resourceGroups/rg-network-tss-eastus2-01/providers/Microsoft.Network/privateDnsZones/privatelink.eastus2.azmk8s.io"
SUBNET="/subscriptions/f08b1fe3-f4f7-4c0a-bb51-d6a47cf1a81c/resourceGroups/rg-network-tbd-eastus2-01/providers/Microsoft.Network/virtualNetworks/vn-tbd-eastus2/subnets/snet-tbd-eastus2-004"
ID="/subscriptions/f08b1fe3-f4f7-4c0a-bb51-d6a47cf1a81c/resourceGroups/rg-dsv-aks/providers/Microsoft.ManagedIdentity/userAssignedIdentities/aks-dev-tbd-eastus2-01"


az aks create --resource-group $AKS_RG \
  --name $AKS_NAME \
    --load-balancer-sku standard \
      --vm-set-type VirtualMachineScaleSets \
        --enable-private-cluster \
          --network-plugin kubenet \
            --vnet-subnet-id $SUBNET\
                --dns-service-ip 10.2.0.10 \
                  --service-cidr 10.2.0.0/24 \
                    --network-policy calico \
                    --enable-managed-identity --assign-identity $ID \
                      --private-dns-zone $DNS_ID\
                       --outbound-type userDefinedRouting \
                          --http-proxy-config aks-proxy-config.json \
                                 --enable-cluster-autoscaler  \
                                   --min-count 3 --max-count 5 \
                                    --node-vm-size "Standard_D4s_v3" \
                                      --ssh-key-value "~/.ssh/id_rsa.pub" \
                                        --kubernetes-version "1.26.3" \
                                          --tags "idorcamento=ID000006" \
                                          --nodepool-tags "idorcamento=ID000006" \
                                            --location eastus2 \
                                              --dns-name-prefix $AKS_NAME

AKS_ID=$(az aks list -o tsv --query '[].id' | grep hlg)
RG=$(az aks list -o tsv --query '[].resourceGroup' | grep hlg)
AKS_NAME=$(az aks list -o tsv --query '[].name' | grep hlg)
NODE_POOL=$(az aks nodepool list --cluster-name $AKS_NAME --resource-group $RG --query '[].name' -o tsv)


   az aks update --resource-group $RG --name $AKS_NAME -y && \
        az aks nodepool update --resource-group $RG --cluster-name $AKS_NAME --name $NODE_POOL