variable "node_ova_file" {
  description = "OVA file for the node"
  type = string
}

variable "node_hostname" {
  description = "Hostname for the k8s node"
  type = string
}

variable "node_domainname" {
  description = "Domain name for the k8s node"
  type = string
}

variable "node_cpus" {
  description = "Number of vcpus for the node"
  type = number
}

variable "node_memory" {
  description = "Memory allocation for the node"
  type = number
}

variable "node_disk_store" {
  type = string
  nullable = false
}

variable "node_vnet" {
  description = "VMWare virtual network"
  type = string
}

variable "node_ssh_pubkey" {
  description = "SSH public key"
  type = string
}

variable "node_ssh_privkey" {
  description = "SSH private key"
  type = string
}
