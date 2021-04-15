variable "location" {
  description = "The location where resources will be created"
  default     = "westeurope"
}

variable "tags" {
  description = "A map of the tags to use for the resources that are deployed"
  type        = map(string)
  default = {
    environment = "lab"
  }
}

variable "resource_group_name" {
  description = "The name of the resource group in which the resources will be created"
  default     = "lab"
}

variable "application_port" {
  description = "The exposed load balancer port"
  default     = 80
}

variable "vmss_user" {
  description = "User name to use as admin account in the Virtual Machines"
  sensitive   = true
}

variable "vmss_password" {
  description = "Password for admin account"
  sensitive   = true
}

variable "quantity" {
  description = "Number of virtual machines that are in the scale set"
  default     = 1
}