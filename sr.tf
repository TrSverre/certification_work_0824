terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
}

provider "yandex" {
  zone = "ru-central1-a"
}

variable "paramsvm" {
  description = "параметры машин"
  type        = map(string)
  default     = {
    namevm1     = "lessonvm1",
    cor1        = 4,
    mem1        = 4,
    namevm2     = "lessonvm2",
    cor2        = 2,
    mem2        = 2,
  }
} 

data "yandex_compute_image" "ubuntu_image" {
  family = "ubuntu-2004-lts"
}


resource "yandex_compute_instance" "vm-1" {
  name = var.paramsvm.namevm1
  allow_stopping_for_update = true
  resources {
    cores  = var.paramsvm.cor1
    memory = var.paramsvm.mem1
  }

  boot_disk {
    disk_id =  yandex_compute_disk.hddvm1.id
  }

  network_interface {
    subnet_id = "e9bn6jti153pnjcqpf8q"
    nat       = true
  }

  metadata = {
    user-data = "${file("./user.yml")}"
  }
  scheduling_policy {
    preemptible = true 
  }

}

resource "yandex_compute_disk" "hddvm1" {
  type     = "network-hdd"
  zone     = "ru-central1-a"
  image_id = data.yandex_compute_image.ubuntu_image.id
  size = 15
}

resource "yandex_compute_instance" "vm-2" {
  name = var.paramsvm.namevm2
 # id = var.paramsvm.namevm2
  allow_stopping_for_update = true
  resources {
    cores  = var.paramsvm.cor2
    memory = var.paramsvm.mem2
  }

  boot_disk {
    disk_id =  yandex_compute_disk.hddvm2.id
  }

  network_interface {
    subnet_id = "e9bn6jti153pnjcqpf8q"
    nat       = true
  }

  metadata = {
    user-data = "${file("./user.yml")}"
  }
  scheduling_policy {
    preemptible = true 
  }

}

resource "yandex_compute_disk" "hddvm2" {
  type     = "network-hdd"
  zone     = "ru-central1-a"
  image_id = data.yandex_compute_image.ubuntu_image.id
  size = 15
}