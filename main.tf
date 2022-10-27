terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }

}

provider "yandex" {
  token     = "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
  cloud_id  = "XXXXXXXXXXXXXXXXXXXX"
  folder_id = "XXXXXXXXXXXXXXXXXXXX"
  zone      = "ru-central1-a"
}

resource "yandex_iam_service_account" "terr1" {
  folder_id = "XXXXXXXXXXXXXXXXX"
  name      = "tf-editor-account"
}

resource "yandex_resourcemanager_folder_iam_member" "sa-terr1" {
  folder_id = "XXXXXXXXXXXXX"
  role      = "storage.admin"
  member    = "serviceAccount:${yandex_iam_service_account.terr1.id}"
}

resource "yandex_iam_service_account_static_access_key" "sa-static-key" {
  service_account_id = yandex_iam_service_account.terr1.id
  description        = "static access key for object storage"
}


resource "yandex_storage_bucket" "t2-state" {
  bucket     = "terr2-state"
  access_key = yandex_iam_service_account_static_access_key.sa-static-key.access_key
  secret_key = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
  acl        = "private"

  versioning {
    enabled = true
  }
}
terraform {
  backend "s3" {
    endpoint   = "storage.yandexcloud.net"
    bucket     = "terr2-state"
    region     = "ru-central1"
    key        = "terraform.tfstate"
    access_key = "xxxxxxxxxxxxxxxxxxx"
    secret_key = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"

   skip_region_validation      = true
    skip_credentials_validation = true
  }
}

resource "yandex_compute_instance" "node-1" {
  name = "node-1"

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = "fd83uvj8kqqmat838872"
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.vpc1.id
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }
}

resource "yandex_compute_instance" "node-2" {
  name = "node-2"

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = "fd83uvj8kqqmat838872"
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.vpc1.id
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }
}

resource "yandex_compute_instance" "node-3" {
  name = "node-3"

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = "fd83uvj8kqqmat838872"
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.vpc2.id
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }
}

resource "yandex_vpc_network" "network-1" {
  name = "network1"
}

resource "yandex_vpc_subnet" "vpc1" {
  name           = "vpc1"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.network-1.id
  v4_cidr_blocks = ["192.168.10.0/24"]
}

resource "yandex_vpc_subnet" "vpc2" {
  name           = "vpc2"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.network-1.id
  v4_cidr_blocks = ["192.168.20.0/24"]
}

