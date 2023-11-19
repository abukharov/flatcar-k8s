provider "esxi" {
  esxi_hostname = var.esxi_hostname
  esxi_hostport = var.esxi_hostport
  esxi_hostssl  = var.esxi_hostssl
  esxi_username = var.esxi_username
  esxi_password = var.esxi_password
}

data "ignition_user" "cluster_user" {
  name = "core"

  ssh_authorized_keys = [file(var.ssh_pubkey)]
}

data "ignition_config" "coreos" {
  users = [
    data.ignition_user.cluster_user.rendered,
  ]
}

resource "esxi_guest" "esxi_vm" {
  guest_name         = var.node_hostname
  disk_store         = var.node_disk_store
  boot_firmware      = "bios"
  guestos            = "other5xlinux-64"
  virthwver          = 19
  power              = "on"
  memsize            = "2048"
  numvcpus           = "2"

  guestinfo = {
    "coreos.config.data.encoding" = "base64"
    "coreos.config.data" = base64encode(data.ignition_config.coreos.rendered)
  }

  ovf_source         = "../images/flatcar_production_vmware_ova.ova"

  network_interfaces {
    virtual_network = var.node_vnet
  }

  connection {
    host        = self.ip_address
    type        = "ssh"
    user        = "core"
    private_key = file(var.ssh_privkey)
    timeout     = "180s"
  }

  provisioner "remote-exec" {
    inline = [
      "timedatectl set-timezone Australia/Melbourne",
    ]
  }

}

output "ip_address" {
  description = "IP address of the node"
  value = esxi_guest.esxi_vm.ip_address
}
