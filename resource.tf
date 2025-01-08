#resource group 
resource "azurerm_resource_group" "rg" {
  name = var.rg_name
  location = var.location
}
#virtual network creating
resource "azurerm_virtual_network" "vnet" {
  name = var.vnet_name
  resource_group_name = azurerm_resource_group.rg.name
  address_space = var.address_space
  location = var.location
}
#subnet creating 
resource "azurerm_subnet" "sbnet" {
  name                 = var.subnet_name
  resource_group_name  = azurerm_resource_group.rg
  virtual_network_name = azurerm_virtual_network.vnet
  address_prefixes     = var.subnet_space
}
#azure ssh key generate
resource "azurerm_ssh_public_key" "ssh" {
  name                = var.key
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  public_key          = file("~/.ssh/id_rsa.pub")
}
#public ip creating
resource "azurerm_public_ip" "pip" {
  name = var.pip_name
  resource_group_name  = azurerm_resource_group.rg
  location             = var.location
  allocation_method    = "Static"
}
#create the NIC(n/w interface card)
resource "azurerm_network_interface" "nic" {
  name                = var.nic_name
  location            = var.location
  resource_group_name = azurerm_resource_group.rg

  ip_configuration {
    name                          = var.ip_name
    subnet_id                     = azurerm_subnet.sbnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.pip.id
  }
}
#linux-virtual machine config
resource "azurerm_linux_virtual_machine" "vm" {
    name                  = var.vm_name
    resource_group_name   = azurerm_resource_group.rg
    location              = var.location
    size                  = var.size
    admin_username        = var.admin_user_name
    network_interface_ids = [azurerm_network_interface.nic.id]
    
    admin_ssh_key {
    username   = var.user
    public_key = file("~/.ssh/id_rsa.pub")
  }
    os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
    source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = var.sku
    version   = "latest"
  }
}
resource "azurerm_network_security_group" "nsg" {
  name                = var.nsg
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "sshport"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}
resource "azurerm_subnet_network_security_group_association" "nsgasoc" {
  subnet_id                 = azurerm_subnet.nic.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}
