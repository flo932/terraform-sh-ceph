# Set the variable value in *.tfvars file

# Set the token in hcloud_token.tfvars like 
# hcloud_token = "xxxxxxxxx"
# or using the -var="hcloud_token=..." CLI option

variable "hcloud_token" {
  sensitive = true # Requires terraform >= 0.14
}

# Configure the Hetzner Cloud Provider
provider "hcloud" {
 token = "${var.hcloud_token}"
}

# Create a new SSH key
resource "hcloud_ssh_key" "default" {
  name       = "ssh-key-A"
  public_key = file("ssh-key.pub")
}

# -----------------------------------------
resource "hcloud_network" "net1" {
  name     = "cluster"
  ip_range = "10.0.1.0/24" #8
}
resource "hcloud_network" "net2" {
  name     = "public"
  ip_range = "10.0.2.0/24" #8
}

resource "hcloud_network_subnet" "cluster" {
  network_id   = hcloud_network.net1.id
  type         = "cloud"
  network_zone = "eu-central"
  ip_range     = "10.0.1.0/24"
}
resource "hcloud_network_subnet" "public" {
  network_id   = hcloud_network.net2.id
  type         = "cloud"
  network_zone = "eu-central"
  ip_range     = "10.0.2.0/24"
}
# -----------------------------------------



# Create a server ---------------------------------
resource "hcloud_server" "c-1" {
  name        = "ceph0"
  ssh_keys   = ["ssh-key-A"]
  location   = "fsn1"
  image       = "debian-11"
  #image       = "installimage"
  server_type = "cx11"
}

resource "hcloud_server_network" "srvnetwork1-1" {
  server_id  = hcloud_server.c-1.id
  network_id = hcloud_network.net1.id
  ip         = "10.0.1.5"
}
resource "hcloud_server_network" "srvnetwork1-2" {
  server_id  = hcloud_server.c-1.id
  network_id = hcloud_network.net2.id
  ip         = "10.0.2.5"
}

# Create a volume
resource "hcloud_volume" "storage-1" {
  name       = "ceph-disk"
  size       = 11
  server_id  = "${hcloud_server.c-1.id}"
  automount  = true
  format     = "ext4"
}





# Create a server ---------------------------------
resource "hcloud_server" "c-2" {
  name        = "ceph1"
  ssh_keys   = ["ssh-key-A"]
  location   = "fsn1"
  image       = "debian-11"
  #image       = "installimage"
  server_type = "cx11"
}

resource "hcloud_server_network" "srvnetwork2-1" {
  server_id  = hcloud_server.c-2.id
  network_id = hcloud_network.net1.id
  ip         = "10.0.1.6"
}
resource "hcloud_server_network" "srvnetwork2-2" {
  server_id  = hcloud_server.c-2.id
  network_id = hcloud_network.net2.id
  ip         = "10.0.2.6"
}

# Create a volume
resource "hcloud_volume" "storage-2" {
  name       = "my-volume-2"
  size       = 11
  server_id  = "${hcloud_server.c-2.id}"
  automount  = true
  format     = "ext4"
}





# Create a server ---------------------------------
resource "hcloud_server" "c-3" {
  name        = "ceph2"
  ssh_keys   = ["ssh-key-A"]
  location   = "fsn1"
  image       = "debian-11"
  #image       = "installimage"
  server_type = "cx11"
}
resource "hcloud_server_network" "srvnetwork3-1" {
  server_id  = hcloud_server.c-3.id
  network_id = hcloud_network.net1.id
  ip         = "10.0.1.7"
}
resource "hcloud_server_network" "srvnetwork3-2" {
  server_id  = hcloud_server.c-3.id
  network_id = hcloud_network.net2.id
  ip         = "10.0.2.7"
}

# Create a volume
resource "hcloud_volume" "storage-3" {
  name       = "my-volume-3"
  size       = 11
  server_id  = "${hcloud_server.c-3.id}"
  automount  = true
  format     = "ext4"
}




