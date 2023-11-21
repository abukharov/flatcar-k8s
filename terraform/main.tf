provider "esxi" {
  esxi_hostname = var.esxi_hostname
  esxi_hostport = var.esxi_hostport
  esxi_hostssl  = var.esxi_hostssl
  esxi_username = var.esxi_username
  esxi_password = var.esxi_password
}

provider "opnsense" {
  uri = var.opnsense_uri
  user = var.opnsense_username
  password = var.opnsense_password
}

module "masters" {
  source = "./modules/k8s_node"

  providers = {
    esxi = esxi
    ignition = ignition
  }

  node_ova_file = "../images/flatcar_production_vmware_ova.ova"
  node_domainname = "cosmos.st"
  node_vnet = "VM Network"
  node_ssh_pubkey = "../files/alexv.pub"
  node_ssh_privkey = var.ssh_privkey

  for_each = var.cluster_masters
  node_hostname = each.key
  node_cpus = each.value.node_cpus
  node_memory = each.value.node_memory
  node_disk_store = each.value.node_disk_store
}

module "workers" {
  source = "./modules/k8s_node"

  providers = {
    esxi = esxi
    ignition = ignition
  }

  node_ova_file = "../images/flatcar_production_vmware_ova.ova"
  node_domainname = "cosmos.st"
  node_vnet = "VM Network"
  node_ssh_pubkey = "../files/alexv.pub"
  node_ssh_privkey = var.ssh_privkey

  for_each = var.cluster_nodes
  node_hostname = each.key
  node_cpus = each.value.node_cpus
  node_memory = each.value.node_memory
  node_disk_store = each.value.node_disk_store
}

resource "opnsense_dhcp_static_map" "node_dhcp_map" {
  interface = var.opnsense_iface

  for_each = merge(module.masters, module.workers)
  mac = each.value.mac_address
  ipaddr = each.value.ip_address
  hostname = each.value.hostname
}

resource "local_file" "inventory" {
  content = templatefile("${path.module}/templates/inventory.tpl", {
    connection_strings_master = join("\n", formatlist("%s ansible_user=core ansible_host=%s etcd_member_name=etcd%d",
      values(module.masters).*.fqdn,
      values(module.masters).*.ip_address,
    range(1, length(keys(module.masters)) + 1))),
    connection_strings_worker = join("\n", formatlist("%s ansible_user=core ansible_host=%s",
      values(module.workers).*.fqdn,
      values(module.workers).*.ip_address)),
    list_master = join("\n", formatlist("%s", values(module.masters).*.fqdn)),
    list_worker = join("\n", formatlist("%s", values(module.workers).*.fqdn))
  })
  filename = var.inventory_file
}
