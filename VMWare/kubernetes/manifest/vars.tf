variable "worker_instances" {
    description = "The number of worker instances to be created"
    default = 2
}

variable "master_ip" {
    description = "The IP address that will be assigned to the Kubernetes master"
    type = string
}

variable "master_ip_netmask" {
    description = "The netmask to be used in conjunction with master_ip"
    type = number
}

variable "worker_ip_base" {
    description = "The first three octets of the IP address to be used by the worker instances"
    type = string
}

variable "worker_ip_start_octet" {
    description = "The value of the last octet of the IP address that will get incremented for each worker instance"
    type = number
}

variable "worker_ip_netmask" {
    description = "The netmask to be used in conjunction with the worker IP"
    type = number
}

variable "ip_gateway" {
    description = "The IP address of the default gateway"
    type = string
}

variable "dns_server_list" {
    description = "An array of IP addresses to be used for name resolution"
    type = list(string)
}

variable "vc_template_name" {
    description = "The name of the template in vCenter to clone"
    type = string
}

variable "vc_url" {
    description = "The URL of the vCenter appliance"
    type = string
}

variable "vc_datacenter_name" {
    description = "The name of the datacenter within vCenter to deploy the instances to"
    type = string
}

variable "vc_cluster_name" {
    description = "The name of the cluster to use when deploying the instances"
    type = string
}

variable "vc_network_name" {
    description = "The name of the virtual network adapter to assign to each instance"
    type = string
}

variable "vc_datastore_name" {
    description = "The name of the datastore that the instance disks will be located on"
    type = string
}

variable "vc_esxi_host_name" {
    description = "The name of the ESXi host"
    type = string
}

variable "vc_folder_name" {
    description = "The folder path within vCenter to place the instances under"
    type = string
}

variable "domain_name" {
    description = "The domain name to append to the end of each instance hostname"
    type = string
}

variable "vc_user" {
    description = "The username used for authenticating with vCenter"
    type = string
}

variable "vc_password" {
    description = "The password used for authenticating with vCenter"
    type = string
}