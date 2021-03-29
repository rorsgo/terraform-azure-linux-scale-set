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