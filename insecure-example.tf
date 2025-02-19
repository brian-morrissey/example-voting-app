provider "azurerm" {
  features {}
}

# Insecure Network Security Group (NSG)
resource "azurerm_network_security_group" "open_nsg" {
  name                = "open-nsg"
  location            = "East US"
  resource_group_name = "myResourceGroup"

  security_rule {
    name                       = "AllowAllInbound"
    priority                  = 100
    direction                 = "Inbound"
    access                    = "Allow"
    protocol                  = "*"
    source_port_range         = "*"
    destination_port_range    = "*"
    source_address_prefix     = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "AllowAllOutbound"
    priority                  = 200
    direction                 = "Outbound"
    access                    = "Allow"
    protocol                  = "*"
    source_port_range         = "*"
    destination_port_range    = "*"
    source_address_prefix     = "*"
    destination_address_prefix = "*"
  }
}

# Insecure Azure VM without encryption or private IP
resource "azurerm_linux_virtual_machine" "insecure_vm" {
  name                = "insecure-vm"
  resource_group_name = "myResourceGroup"
  location            = "East US"
  size                = "Standard_B1s"
  admin_username      = "adminuser"
  admin_password      = "P@ssw0rd1234"  # Weak password

  network_interface_ids = [
    azurerm_network_interface.insecure_nic.id
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"  # No encryption on disk
  }

  # Public IP for VM (exposing to the internet)
  public_ip_address {
    name = "insecure-vm-public-ip"
  }
}

# Network Interface for VM with Public IP
resource "azurerm_network_interface" "insecure_nic" {
  name                = "insecure-nic"
  location            = "East US"
  resource_group_name = "myResourceGroup"

  ip_configuration {
    name                          = "internal"
    subnet_id                    = azurerm_subnet.default.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id         = azurerm_public_ip.insecure_public_ip.id
  }
}

# Public IP Address for VM
resource "azurerm_public_ip" "insecure_public_ip" {
  name                = "insecure-public-ip"
  location            = "East US"
  resource_group_name = "myResourceGroup"
  allocation_method   = "Dynamic"
}

# Insecure Storage Account without encryption
resource "azurerm_storage_account" "insecure_storage" {
  name                     = "insecurestorage123"
  resource_group_name      = "myResourceGroup"
  location                 = "East US"
  account_tier              = "Standard"
  account_replication_type = "LRS"

  # No encryption enabled (uses default, which is not recommended)
  enable_https_traffic_only = true  # HTTPS enforced but no encryption options enabled for data
}

# Insecure Blob Storage container with public access
resource "azurerm_storage_container" "insecure_blob_container" {
  name                  = "insecurecontainer"
  storage_account_name  = azurerm_storage_account.insecure_storage.name
  container_access_type = "container"  # Allows public read access to the container
}

# Insecure Azure SQL Database without encryption
resource "azurerm_sql_server" "insecure_sql_server" {
  name                         = "insecure-sql-server"
  resource_group_name          = "myResourceGroup"
  location                     = "East US"
  version                      = "12.0"
  administrator_login          = "sqladmin"
  administrator_login_password = "StrongP@ssw0rd123"

  tags = {
    environment = "development"
  }
}

resource "azurerm_sql_database" "insecure_sql_database" {
  name                = "insecure-db"
  resource_group_name = "myResourceGroup"
  location            = "East US"
  server_name         = azurerm_sql_server.insecure_sql_server.name
  sku_name            = "S1"

  # No encryption configuration on database
}

