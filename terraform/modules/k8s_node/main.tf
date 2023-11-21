resource "macaddress" "guest_mac" {
  prefix = [50, 214, 208]
}

data "ignition_user" "cluster_user" {
  name = "core"

  ssh_authorized_keys = [file(var.node_ssh_pubkey)]
}

data "ignition_file" "etc_hostname" {
  path = "/etc/hostname"
  content {
    content = "${var.node_hostname}\n"
  }
}

data "ignition_file" "networkd_config" {
  path = "/etc/systemd/network/00-dhcp-en.network"
  content {
    content = <<EOF
[Match]
Name=en*
[Network]
DHCP=yes
SendHostname=yes
Hostname=${var.node_hostname}
EOF
  }
}

data "ignition_config" "coreos" {
  users = [
    data.ignition_user.cluster_user.rendered,
  ]

  files = [
    data.ignition_file.etc_hostname.rendered,
  ]
}

resource "esxi_guest" "esxi_vm" {
  guest_name         = var.node_hostname
  disk_store         = var.node_disk_store
  boot_firmware      = "bios"
  guestos            = "other5xlinux-64"
  virthwver          = 19
  power              = "on"
  memsize            = var.node_memory
  numvcpus           = var.node_cpus

  guestinfo = {
    "coreos.config.data.encoding" = "base64"
    "coreos.config.data" = base64encode(data.ignition_config.coreos.rendered)
  }

  ovf_source         = var.node_ova_file

  network_interfaces {
    virtual_network = var.node_vnet
    mac_address = macaddress.guest_mac.address
  }

  connection {
    host        = self.ip_address
    type        = "ssh"
    user        = "core"
    private_key = file(var.node_ssh_privkey)
    timeout     = "180s"
  }

  provisioner "file" {
    destination = "/tmp/hosts.tmp"
    content     = templatefile("${path.module}/templates/hosts.tftpl", {
      ipaddress = esxi_guest.esxi_vm.ip_address
      hostname = var.node_hostname,
      domainname = var.node_domainname,
    })
  }

  provisioner "remote-exec" {
    inline = [
      "sudo timedatectl set-timezone Australia/Melbourne",
      "sudo cp /tmp/hosts.tmp /etc/hosts",
    ]
  }

}

output "hostname" {
  description = "Hostname of the node"
  value = var.node_hostname
}

output "fqdn" {
  description = "FQDN of the node"
  value = "${var.node_hostname}.${var.node_domainname}"
}

output "ip_address" {
  description = "IP address of the node"
  value = esxi_guest.esxi_vm.ip_address
}

output "mac_address" {
  description = "MAC address of the node"
  value = macaddress.guest_mac.address
}
