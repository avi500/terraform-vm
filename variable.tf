#resource group name
variable "rg_name" {
  default = "terraform_rg"
}
variable "location" {
  default = "westus2"
}
variable "address_space" {
  type    = list(string)
  default = ["10.1.0.0/16"]
}

#virtual network 
variable "vnet_name" {
  default = "terraform_vnet"
}

#subnet
variable "subnet_name" {
  default = "terraform_snet"
}
variable "subnet_space" {
  type    = list(string)
  default = ["10.1.0.0/24", "10.1.10.0/24"]
}

#ssh key generate 
variable "key" {
  default = "ssh_key"
}
#public ip-config in nic generate
variable "ip_name" {
  default = "ip"
}
variable "pip_name" {
  default = "pip"
}
#network interface card
variable "nic_name" {
  default = "nic"
}
#vm creating
variable "vm-name" {
  default = "vm-name"
}
variable "size" {
  default = "Standard_B1s"
}
variable "admin_user_name" {
  default = "avi"
}
#vm- admin_ssh_key
variable "user" {
  default = "avi"
}
#vm- source_image_reference
variable "sku" {
  default = "22_04-lts"
}
#network-security-group
variable "nsg" {
  default = "nsg"
}
#window vm-name
variable "myWindowsVM" {
  default = "myWindowsVM"
}
variable "username" {
  default = "avi"
}
variable "password" {
  default = "avi@14376"
}
