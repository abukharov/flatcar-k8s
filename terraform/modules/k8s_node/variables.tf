variable "esxi_hostname" {
  type = string
  nullable = false
}

variable "esxi_hostport" {
  default = "22"
}

variable "esxi_hostssl" {
  default = "443"
}

variable "esxi_username" {
  type = string
  nullable = false
  sensitive = true
}

variable "esxi_password" {
  type = string
  nullable = false
  sensitive = true
}

variable "node_hostname" {
  description = "Hostname for the k8s node"
  type = string
}

variable "node_disk_store" {
  type = string
  nullable = false
}

variable "node_vnet" {
  description = "VMWare virtual network"
  type = string
}

variable "ssh_pubkey" {
  description = "SSH public key"
  type = string
}

variable "ssh_privkey" {
  description = "SSH private key"
  type = string
}
