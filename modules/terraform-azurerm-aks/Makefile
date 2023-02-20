# Terraform-Azurerm-Vnet
all: cleanup prepare-readme

.PHONY: cleanup

cleanup: 
	rm ./README.md

prepare-readme: 
	echo "Preparando nova documentação"
	terraform-docs -c .terraform-docs.yaml markdown table ./ --output-file "README.md" 
	cd example/private-cluster/
	terraform-docs -c .terraform-docs.yaml markdown table ./ --output-file "README.md"
