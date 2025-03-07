# Описание Web серверов

###################
# WEB SERVER  № 1 #
###################

resource "yandex_compute_instance" "webserver-1" {
  name = "webserver-1"
  hostname = "webserver-1"
  zone = "ru-central1-a"
  allow_stopping_for_update = true

  resources {
    core_fraction = 20
    cores         = 2
    memory        = 2
  }

  boot_disk {
    initialize_params {
      image_id = "fd8s17cfki4sd4l6oa59"
      size     = 5
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.bastion-internal-segment.id
    security_group_ids = [ 
                           yandex_vpc_security_group.internal-ssh-sg.id,
                           yandex_vpc_security_group.alb-vm-sg.id,
                           yandex_vpc_security_group.zabbix-sg.id,
                           yandex_vpc_security_group.egress-sg.id
                         ]
/*    security_group_ids = [
                            yandex_vpc_security_group.external-ssh-sg.id,
                            yandex_vpc_security_group.internal-ssh-sg.id
                           ] */

    nat       = false
    ip_address = "192.168.10.10"
  }

  metadata = {
    user-data = "${file("./meta.yaml")}"
  }

  scheduling_policy {
    preemptible = false
  }

}

##########################################################################################

###################
# WEB SERVER  № 2 #
###################

resource "yandex_compute_instance" "webserver-2" {
  name = "webserver-2"
  hostname = "webserver-2"
  zone = "ru-central1-a"
  allow_stopping_for_update = true

  resources {
    core_fraction = 20
    cores         = 2
    memory        = 2
  }

  boot_disk {
    initialize_params {
      image_id = "fd8s17cfki4sd4l6oa59"
      size     = 5
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.bastion-internal-segment.id
    security_group_ids = [ 
                           yandex_vpc_security_group.internal-ssh-sg.id,
                           yandex_vpc_security_group.alb-vm-sg.id,
                           yandex_vpc_security_group.zabbix-sg.id,
                           yandex_vpc_security_group.egress-sg.id
                         ]

/*    security_group_ids = [
                            yandex_vpc_security_group.external-ssh-sg.id,
                            yandex_vpc_security_group.internal-ssh-sg.id
                           ] */
    nat       = false
    ip_address = "192.168.10.20"
  }

  metadata = {
    user-data = "${file("./meta.yaml")}"
  }

    scheduling_policy {
    preemptible = false
  }
}