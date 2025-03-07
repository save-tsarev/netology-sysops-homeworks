terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
}

provider "yandex" {
  token     = "t1.9euelZqOxoqKkYuenMqdnIyem8aWzO3rnpWay56KnpCQk4yNy5SKzJzLkJrl8_dvGUVI-e92SSVk_d3z9y9IQkj573ZJJWT9zef1656VmsfJx8nNiYqMmsuOlYnHxsue7_zF656VmsfJx8nNiYqMmsuOlYnHxsue.-qZkICJZO_2Cg_DI46f4S9a30OOQDEbbcxC3m142-nplpmvuuljALXi2G3xGUD-b_78WPxh0zdESpsbspu7KBg"
  cloud_id  = "b1g2ctv6o2a410617f1d"
  folder_id = "b1gvdk8neje03f293jeb"
}

resource "yandex_vpc_network" "network-1" {
  name = "network1"
}

resource "yandex_vpc_subnet" "subnet-1" {
  name           = "subnet1"
  zone           = "ru-central1-b"
  network_id     = yandex_vpc_network.network-1.id
  v4_cidr_blocks = ["192.168.10.0/24"]
}

resource "yandex_compute_instance" "vm-1" {
  name = "terraform-vm"
  zone = "ru-central1-b"

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = "fd87kbts7j40q5b9rpjr"  # ID образа ОС, например Ubuntu
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-1.id
    nat       = true
  }

  metadata = {
    user-data = "${file("./meta.txt")}"
  }

  scheduling_policy {
    preemptible = false
  }

  allow_stopping_for_update = true
}

output "external_ip_address_vm_1" {
  value = yandex_compute_instance.vm-1.network_interface.0.nat_ip_address
}
