resource "yandex_vpc_network" "kube-network" {
  name = "k8s-network"
}

resource "yandex_vpc_subnet" "kube-subnet" {
  name           = "k8s-subnet"
  zone           = var.zone
  network_id     = yandex_vpc_network.kube-network.id
  v4_cidr_blocks = ["192.168.10.0/24"]
}
