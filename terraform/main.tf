module "magi" {
  source = "./modules/k8s_node"

  esxi_hostname = var.esxi_hostname
  esxi_hostport = var.esxi_hostport
  esxi_hostssl  = var.esxi_hostssl
  esxi_username = var.esxi_username
  esxi_password = var.esxi_password

  node_hostname = "magi"
  node_disk_store = "datastore1"
  node_vnet = "VM Network"
  ssh_pubkey = "../files/alexv.pub"
  ssh_privkey = var.ssh_privkey
}
