#!/usr/bin/env bash 

ENV=$1
#FUNCTION
function terraform-install() {
  [[ -f ${HOME}/bin/terraform ]] && echo "`${HOME}/bin/terraform version` already installed at ${HOME}/bin/terraform" && return 0
  
  LATEST_URL=$(curl -sL https://releases.hashicorp.com/terraform/index.json | jq -r '.versions[].builds[].url' | sort -t. -k 1,1n -k 2,2n -k 3,3n -k 4,4n | egrep -v 'rc|beta' | egrep 'linux.*amd64' |tail -1)
  
  curl ${LATEST_URL} > /tmp/terraform.zip
  mkdir -p ${HOME}/bin
  (cd ${HOME}/bin && unzip /tmp/terraform.zip)
  if [[ -z $(grep 'export PATH=${HOME}/bin:${PATH}' ~/.bashrc) ]]; then
  	echo 'export PATH=${HOME}/bin:${PATH}' >> ~/.bashrc
  fi
  
  echo "Installed: `${HOME}/bin/terraform version`"
  
}

CMD=az
if ! command -v $CMD &> /dev/null;
then
    echo "$CMD Não encontrado"
    echo "Instalando azure cli"
    sudo curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash 
    exit
else
  echo "azure cli OK - Seguindo com testes"
 
fi


TF=terraform
if ! command -v $TF &> /dev/null;
then
    echo "$TF Não encontrado"
    terraform-install
    exit
else
  echo "CMD OK - Seguindo com testes"
 
fi

echo "rodando terraform"

terraform apply -var-file=./envs/dev.tfvars -target="module.aks_$ENV" -auto-approve > tf_log.log 2>&0 2>&1

ERR_AKS="CreateVMSSAgentPoolFailed"


AKS_ID=$(az aks list -o tsv --query '[].id' | grep $ENV)
RG=$(az aks list -o tsv --query '[].resourceGroup' | grep $ENV)
AKS_NAME=$(az aks list -o tsv --query '[].name' | grep $ENV)
NODE_POOL=$(az aks nodepool list --cluster-name $AKS_NAME --resource-group $RG --query '[].name' -o tsv)

if grep -wq "$ERR_AKS" tf_log.log; then 
    echo "Falha no deploy do node, reescrevendo node para solução do probelma com dns do azure"
    az aks update --resource-group $RG --name $AKS_NAME && \
        az aks nodepool update --resource-group $RG --cluster-name $AKS_NAME --name $NODE_POOL
else 
    echo "All OK - Segue a vida !"
fi

CHK_STATE=`terraform state list  | grep module.aks_hlg.azurerm_kubernetes_cluster.main`
if [ -z $CHK_STATE ]; then
  echo "Importando aks para state"
  EFIX=$(echo "$AKS_ID" | sed "s/resourcegroups/resourceGroups/g")
  terraform import -var-file=./envs/dev.tfvars  module.aks_$ENV.azurerm_kubernetes_cluster.main $EFIX


else
  echo "Cluster de aks já se encontra no state"
fi

  echo "Rodando Aks novamente para atualizar nodepools"
  terraform apply -var-file=./envs/dev.tfvars -target="module.aks_$ENV" -auto-approve > tf_log.log 2>&0 2>&1