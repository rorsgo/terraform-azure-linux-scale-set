resource "azurerm_resource_group" "vmss" {
    name     = var.resource_group_name
    location = var.location
    tags     = var.tags
}

resource "random_string" "fqdn" {
    length  = 6
    special = false
    upper   = false
    number  = false
}

resource "azurerm_virtual_network" "vmss" {
    name                = "vmss-vnet"
    address_space       = ["10.0.0.0/16"]
    location            = var.location
    resource_group_name = azurerm_resource_group.vmss.name
    tags                = var.tags
}

resource "azurerm_subnet" "vmss" {
    name                 = "vmss-subnet"
    resource_group_name  = azurerm_resource_group.vmss.name
    virtual_network_name = azurerm_virtual_network.vmss.name
    address_prefixes       = ["10.0.2.0/24"]
}

resource "azurerm_public_ip" "vmss" {
    name                = "vmss-public-ip"
    location            = var.location
    resource_group_name = azurerm_resource_group.vmss.name
    allocation_method   = "Static"
    domain_name_label   = random_string.fqdn.result
    tags                = var.tags
}

resource "azurerm_lb" "vmss" {
    name                = "vmss-lb"
    location            = var.location
    resource_group_name = azurerm_resource_group.vmss.name

    frontend_ip_configuration {
        name                 = "PublicIPAddress"
        public_ip_address_id = azurerm_public_ip.vmss.id
    }

    tags = var.tags
}

resource "azurerm_lb_backend_address_pool" "vmss" {
    loadbalancer_id     = azurerm_lb.vmss.id
    name                = "BackendAddressPool"
}

resource "azurerm_lb_probe" "vmss" {
    resource_group_name = azurerm_resource_group.vmss.name
    loadbalancer_id     = azurerm_lb.vmss.id
    name                = "ssh-running-probe"
    port                = var.application_port
}

resource "azurerm_lb_rule" "lbnatrule" {
    resource_group_name            = azurerm_resource_group.vmss.name
    loadbalancer_id                = azurerm_lb.vmss.id
    name                           = "http"
    protocol                       = "Tcp"
    frontend_port                  = var.application_port
    backend_port                   = var.application_port
    backend_address_pool_id        = azurerm_lb_backend_address_pool.vmss.id
    frontend_ip_configuration_name = "PublicIPAddress"
    probe_id                       = azurerm_lb_probe.vmss.id
}