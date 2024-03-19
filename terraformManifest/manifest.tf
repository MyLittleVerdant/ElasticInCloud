terraform {
  required_providers {
    rustack = {
      source  = "pilat/rustack"
      version = "> 1.1.0"
    }
  }
}

locals {
  token = '0d35900404df7f09ea9b96f03986c5f48eefd908'
  ssh_key = ''
}
# Configure the Rustack Provider
provider "rustack" {
  api_endpoint = "https://cloud.mephi.ru"
  token        = locals.token
}

# Получаем проект с id
data "rustack_project" "single_project" {
  name= ''
}

# получаем гиппервизоров для создания ВЦОД
data "rustack_hypervisors" "all_hypervisors" {
  project_id = data.rustack_project.single_project.id
}

# создаем ВЦОД
resource "rustack_vdc" "single_vdc" {
  hypervisor_id = data.rustack_hypervisors.all_hypervisors.hypervisors[0].id
  project_id    = data.rustack_project.single_project.id
  name          = "TerraformVDC"
}

# получаем дефолтную сеть
data "rustack_network" "service_network" {
  vdc_id = resource.rustack_vdc.single_vdc.id
  name   = "Сеть"
}

# получаем профиль SSD диска что бы потом передать для создания ВМ
data "rustack_storage_profile" "ssd" {
  vdc_id = resource.rustack_vdc.single_vdc.id
  name   = "ssd"
}

# получаем шаблон машины что бы потом передать для создания ВМ
data "rustack_template" "ubuntu20" {
  vdc_id = resource.rustack_vdc.single_vdc.id
  name   = "Ubuntu 20.04"
}

# получаем шаблон фаерволла что бы потом передать для создания ВМ
data "rustack_firewall_template" "allow_default" {
  vdc_id = resource.rustack_vdc.single_vdc.id
  name   = "Разрешить исходящие"
}

# получаем шаблон фаерволла что бы потом передать для создания ВМ
data "rustack_firewall_template" "allow_web" {
  vdc_id = resource.rustack_vdc.single_vdc.id
  name   = "Разрешить WEB"
}

# получаем шаблон фаерволла что бы потом передать для создания ВМ
data "rustack_firewall_template" "allow_ssh" {
  vdc_id = resource.rustack_vdc.single_vdc.id
  name   = "Разрешить SSH"
}

# получаем шаблон фаерволла что бы потом передать для создания ВМ
data "rustack_firewall_template" "allow_in" {
  vdc_id = resource.rustack_vdc.single_vdc.id
  name   = "Разрешить входящие"
}

resource "rustack_port" "router_port" {
  vdc_id = resource.rustack_vdc.single_vdc.id
  network_id = data.rustack_network.service_network.id
  firewall_templates = [
    data.rustack_firewall_template.allow_default.id,
    data.rustack_firewall_template.allow_web.id,
    data.rustack_firewall_template.allow_ssh.id,
    data.rustack_firewall_template.allow_in.id
  ]
}

resource "rustack_vm" "vm1" {
  vdc_id = resource.rustack_vdc.single_vdc.id
  name        = "Server 1"
  cpu         = 2
  ram         = 4
  template_id = data.rustack_template.ubuntu20.id

  user_data = file("user_data.yaml")

  system_disk {
    size               = 10
    storage_profile_id = data.rustack_storage_profile.ssd.id
  }

  ports = [
    resource.rustack_port.router_port.id
  ]

  power    = true
  floating = true
}

