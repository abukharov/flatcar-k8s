terraform {
  required_version = ">= 0.13"
  required_providers {
    opnsense = {
      source = "gxben/opnsense"
      version = "~> 0.3.0"
    }
    esxi = {
      source = "registry.terraform.io/josenk/esxi"
      version = "~> 1.10.0"
    }
    ignition = {
      source = "community-terraform-providers/ignition"
      version = "~> 2.1.0"
    }
  }
}
