#!/bin/bash

#!/bin/bash

RESOURCE_GROUP_NAME=rg-tf-tss-001
STORAGE_ACCOUNT_NAME=stgtftss001
CONTAINER_NAME=tlf-aks-envs

blob_chk=$(az storage account list --query "[].{name:name}" --output tsv | grep $STORAGE_ACCOUNT_NAME)
if [ $blob_chk = $STORAGE_ACCOUNT_NAME ]
then

    echo "Seu backend já foi criado"

    ACCOUNT_KEY=$(az storage account keys list --resource-group $RESOURCE_GROUP_NAME --account-name $STORAGE_ACCOUNT_NAME --query '[0].value' -o tsv)
    export ARM_ACCESS_KEY=$ACCOUNT_KEY

    echo "STG KEY IS : $ACCOUNT_KEY"

else

    echo "Configurando Backend ... "
    # Create resource group
    az group create --name $RESOURCE_GROUP_NAME --location eastus

    # Create storage account
    az storage account create --resource-group $RESOURCE_GROUP_NAME --name $STORAGE_ACCOUNT_NAME --sku Standard_LRS --encryption-services blob

    # Create blob container
    az storage container create --name $CONTAINER_NAME --account-name $STORAGE_ACCOUNT_NAME

ACCOUNT_KEY=$(az storage account keys list --resource-group $RESOURCE_GROUP_NAME --account-name $STORAGE_ACCOUNT_NAME --query '[0].value' -o tsv)
export ARM_ACCESS_KEY=$ACCOUNT_KEY

echo "STG KEY IS :$ACCOUNT_KEY"
fi