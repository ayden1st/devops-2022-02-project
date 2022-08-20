terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "0.76.0"
    }
  }
}

provider "yandex" {
  service_account_key_file = var.service_account_key_file
  cloud_id                 = var.cloud_id
  folder_id                = var.folder_id
  zone                     = var.zone
}

resource "yandex_kms_symmetric_key" "k8s-key" {
  name              = "k8s-key"
  default_algorithm = "AES_128"
  rotation_period   = "8760h" // equal to 1 year
}

resource "yandex_kubernetes_cluster" "project_k8s" {
  name = "project-k8s"

  network_id = yandex_vpc_network.kube-network.id

  master {
    version = var.k8s_version
    zonal {
      zone      = yandex_vpc_subnet.kube-subnet.zone
      subnet_id = yandex_vpc_subnet.kube-subnet.id
    }

    public_ip = true

    maintenance_policy {
      auto_upgrade = true

      maintenance_window {
        start_time = "15:00"
        duration   = "3h"
      }
    }
  }

  service_account_id      = var.service_account_id
  node_service_account_id = var.node_service_account_id

  release_channel = "RAPID"

  kms_provider {
    key_id = yandex_kms_symmetric_key.k8s-key.id
  }
}

resource "yandex_kubernetes_node_group" "project_k8s_group" {
  cluster_id = yandex_kubernetes_cluster.project_k8s.id
  name       = "project-k8s-group"
  version    = var.k8s_version

  instance_template {
    platform_id = "standard-v1"

    network_interface {
      nat        = true
      subnet_ids = [yandex_vpc_subnet.kube-subnet.id]
    }

    resources {
      memory = var.memory
      cores  = var.cores
    }

    boot_disk {
      type = "network-ssd"
      size = var.disk_size
    }

    scheduling_policy {
      preemptible = false
    }

    container_runtime {
      type = "containerd"
    }

    metadata = {
      ssh-keys = "ubuntu:${file(var.public_key_path)}"
    }
  }

  scale_policy {
    fixed_scale {
      size = var.count_of_instances
    }
  }

  allocation_policy {
    location {
      zone = var.zone
    }
  }

  maintenance_policy {
    auto_upgrade = true
    auto_repair  = true

    maintenance_window {
      day        = "monday"
      start_time = "15:00"
      duration   = "3h"
    }

    maintenance_window {
      day        = "friday"
      start_time = "10:00"
      duration   = "4h30m"
    }
  }
}
