module "common" {
  source = "../.common"
}

#RESOURCE GROUP
resource "azurerm_resource_group" "app_resource_group" {
  name     = local.resource_group
  location = var.region

  tags = merge(local.default_tags, {
    Name = local.resource_group
  })
}

#VIRTUAL NETWORK
resource "azurerm_virtual_network" "vnet" {
  name                = local.vnet
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.app_resource_group.location
  resource_group_name = azurerm_resource_group.app_resource_group.name

  tags = merge(local.default_tags, {
    Name = local.vnet
  })

  depends_on = [azurerm_resource_group.app_resource_group]
}

#SUBNET
resource "azurerm_subnet" "default" {
  name                 = local.subnet
  resource_group_name  = azurerm_resource_group.app_resource_group.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.0.0/24"]

  depends_on = [azurerm_virtual_network.vnet]
}

#PUBLIC IP
resource "azurerm_public_ip" "atc_vm_pip" {
  name                = local.pip
  location            = azurerm_resource_group.app_resource_group.location
  resource_group_name = azurerm_resource_group.app_resource_group.name
  allocation_method   = "Static"

  tags = merge(local.default_tags, {
    Name = local.pip
  })
}


#NETWORK INTERFACE CARD
resource "azurerm_network_interface" "nic" {
  name                = local.nic
  location            = azurerm_resource_group.app_resource_group.location
  resource_group_name = azurerm_resource_group.app_resource_group.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.default.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.atc_vm_pip.id
  }

  tags = merge(local.default_tags, {
    Name = local.nic
  })

  depends_on = [azurerm_subnet.default]
}


resource "azurerm_network_security_group" "nsg" {
  name                = local.nsg
  location            = azurerm_resource_group.app_resource_group.location
  resource_group_name = azurerm_resource_group.app_resource_group.name

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = merge(local.default_tags, {
    Name = local.nsg
  })

  depends_on = [azurerm_network_interface.nic]
}

resource "azurerm_network_interface_security_group_association" "nsg_association" {
  network_interface_id      = azurerm_network_interface.nic.id
  network_security_group_id = azurerm_network_security_group.nsg.id

  depends_on = [azurerm_network_security_group.nsg]
}


#VIRTUAL MACHINE
resource "azurerm_linux_virtual_machine" "atc_vm" {
  name                  = local.vm
  resource_group_name   = azurerm_resource_group.app_resource_group.name
  location              = azurerm_resource_group.app_resource_group.location
  size                  = var.vm_size
  admin_username        = var.vm_user
  custom_data           = filebase64("./user_data/install_dependencies.sh")
  network_interface_ids = [azurerm_network_interface.nic.id]

  admin_ssh_key {
    username   = var.vm_user
    public_key = file(var.vm_kp)
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  tags = merge(local.default_tags, {
    Name = local.vm
  })

  depends_on = [azurerm_subnet.default]
}