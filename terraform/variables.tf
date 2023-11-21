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

variable "opnsense_uri" {
  type = string
  nullable = false
  sensitive = false
}

variable "opnsense_username" {
  type = string
  nullable = false
  sensitive = true
}

variable "opnsense_password" {
  type = string
  nullable = false
  sensitive = true
}

variable "opnsense_iface" {
  type = string
  nullable = false
  sensitive = false
}

variable "ssh_privkey" {
  description = "SSH private key"
  type = string
}

variable "cluster_nodes" {
  type = map(object({
    node_cpus = number
    node_memory = number
    node_disk_store = string
  }))
}

variable "cluster_masters" {
  type = map(object({
    node_cpus = number
    node_memory = number
    node_disk_store = string
  }))
}

variable "inventory_file" {
  description = "Kubespray inventory file"
  type = string
  default = "inventory.ini"
}
