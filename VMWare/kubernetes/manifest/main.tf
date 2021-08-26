# ===============================================================================
# vCenter data gathering
# ===============================================================================

data "vsphere_datacenter" "datacenter" {
    name = var.vc_datacenter_name
}

data "vsphere_datastore" "datastore" {
    name = var.vc_datastore_name
    datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_compute_cluster" "cluster" {
    name = var.vc_cluster_name
    datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_host" "host" {
    name = var.vc_esxi_host_name
    datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_network" "network" {
    name = var.vc_network_name
    datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_virtual_machine" "template" {
    name = var.vc_template_name
    datacenter_id = data.vsphere_datacenter.datacenter.id
}

# ===============================================================================
# Kubernetes master / control-plane
# ===============================================================================

resource "vsphere_virtual_machine" "kubernetes-master" {
    name = "Kubernetes Master"
    resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
    datastore_id = data.vsphere_datastore.datastore.id

    num_cpus = 2
    memory = 4096
    guest_id = data.vsphere_virtual_machine.template.guest_id

    scsi_type = data.vsphere_virtual_machine.template.scsi_type

    folder = var.vc_folder_name

    network_interface {
      network_id = data.vsphere_network.network.id
      adapter_type = data.vsphere_virtual_machine.template.network_interface_types[0]
    }

    disk {
        label = "disk0"
        size = data.vsphere_virtual_machine.template.disks.0.size
        eagerly_scrub = data.vsphere_virtual_machine.template.disks.0.eagerly_scrub
        thin_provisioned = data.vsphere_virtual_machine.template.disks.0.thin_provisioned
    }

    clone {
        template_uuid = data.vsphere_virtual_machine.template.id

        customize {
          linux_options {
            host_name = "kubernetes-master"
            domain = var.domain_name
          }

          network_interface {
            ipv4_address = var.master_ip
            ipv4_netmask = var.master_ip_netmask
          }

          ipv4_gateway = var.ip_gateway

          dns_server_list = var.dns_server_list
        }
    }
}

# ===============================================================================
# Kubernetes workers
# ===============================================================================

resource "vsphere_virtual_machine" "kubernetes-workers" {
    count = var.worker_instances
    name = "Kubernetes Worker 0${count.index + 1}"
    resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
    datastore_id = data.vsphere_datastore.datastore.id

    num_cpus = 2
    memory = 4096
    guest_id = data.vsphere_virtual_machine.template.guest_id

    scsi_type = data.vsphere_virtual_machine.template.scsi_type

    folder = var.vc_folder_name

    network_interface {
      network_id = data.vsphere_network.network.id
      adapter_type = data.vsphere_virtual_machine.template.network_interface_types[0]
    }

    disk {
        label = "disk0"
        size = data.vsphere_virtual_machine.template.disks.0.size
        eagerly_scrub = data.vsphere_virtual_machine.template.disks.0.eagerly_scrub
        thin_provisioned = data.vsphere_virtual_machine.template.disks.0.thin_provisioned
    }

    clone {
        template_uuid = data.vsphere_virtual_machine.template.id

        customize {
          linux_options {
            host_name = "kubernetes-worker0${count.index + 1}"
            domain = var.domain_name
          }

          network_interface {
            ipv4_address = "${var.worker_ip_base}.${var.worker_ip_start_octet + count.index}"
            ipv4_netmask = var.worker_ip_netmask
          }

          ipv4_gateway = var.ip_gateway

          dns_server_list = var.dns_server_list
        }
    }
}