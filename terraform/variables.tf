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

variable "ssh_privkey" {
  description = "SSH private key"
  type = string
}

variable "cluster_nodes" {
  type = list(object({
    name = string
    cpus = number
    memory = number
    disk_store = string
  }))
}
