resource "azurerm_resource_group" "example1" {
  name     = "example-resources"
  location = "West Europe"
}

resource "azurerm_virtual_network" "example1" {
  name                = "example-network"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.example1.location
  resource_group_name = azurerm_resource_group.example1.name
}

resource "azurerm_subnet" "example1" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.example1.name
  virtual_network_name = azurerm_virtual_network.example1.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_network_interface" "example1" {
  name                = "example-nic"
  location            = azurerm_resource_group.example1.location
  resource_group_name = azurerm_resource_group.example1.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.example1.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_windows_virtual_machine" "example1" {
  name                = "example-machine"
  resource_group_name = azurerm_resource_group.example1.name
  location            = azurerm_resource_group.example1.location
  size                = "Standard_F1"
  admin_username      = "adminuser"
  admin_password      = "P@$$w0rd1234!"
  network_interface_ids = [
    azurerm_network_interface.example.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }
}