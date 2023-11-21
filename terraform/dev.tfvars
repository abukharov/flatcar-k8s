esxi_hostname = "medina.cosmos.st"
esxi_hostport = "22"
esxi_hostssl  = "443"
esxi_username = "automation"
esxi_password = "notsecure"

opnsense_uri = "https://tycho.cosmos.st"
opnsense_username = "automation"
opnsense_password = "notsecure"
opnsense_iface = "opt4"

cluster_nodes = {
  "worker0" : {
    node_cpus       = 2
    node_memory     = 2048
    node_disk_store = "datastore2"
  }
}

cluster_masters = {
  "master0" : {
    node_cpus       = 2
    node_memory     = 4096
    node_disk_store = "datastore2"
  },
}
