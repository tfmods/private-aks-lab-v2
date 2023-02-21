# Get the key

## Fill the gap with the storage account name


AKS_PERS_STORAGE_ACCOUNT_NAME="aksstaxpto"

STORAGE_KEY=$(az storage account keys list --resource-group nopublicipaks --account-name $AKS_PERS_STORAGE_ACCOUNT_NAME --query "[0].value" -o tsv)

echo Storage account name: $AKS_PERS_STORAGE_ACCOUNT_NAME
echo Storage account key: $STORAGE_KEY

kubectl create secret generic azure-secret --from-literal=azurestorageaccountname=$AKS_PERS_STORAGE_ACCOUNT_NAME --from-literal=azurestorageaccountkey=$STORAGE_KEY