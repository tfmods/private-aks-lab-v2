
/* output "ssh_command" {
  value = "sudo apt install -y sshpass && sshpass -p ${nonsensitive(module.jumpbox.jumpbox_password)} ssh -o StrictHostKeyChecking=no ${module.jumpbox.jumpbox_username}@${module.jumpbox.jumpbox_ip}"
} */

/* output "jumpbox_password" {
  description = "Jumpbox Admin Passowrd"
  value       = nonsensitive(module.jumpbox.jumpbox_password)
  # sensitive   = true
} */

/* output "queues_created" {
  description = "A list of all the Storage Queues created."
  value       = module.storage_account.queues
}

output "primary_blob_endpoint" {
  description = "The URL of the Primary Storage Account Blob Endpoint."
  value       = module.storage_account.primary_blob_endpoint
}

output "my_ip" {
  value = data.http.ip.response_body
} */


output "public_key" {
  value = module.aks.kube_node_key
  sensitive = true
}
