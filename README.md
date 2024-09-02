# Основы Terraform. Yandex Cloud
# Задание 1.
4. Инициализируйте проект, выполните код. Исправьте намеренно допущенные синтаксические ошибки. Ищите внимательно, посимвольно. Ответьте, в чём заключается их суть.
Ошибки заключались в блоке resource "yandex_compute_instance" "platform". Значения параметра platform_id = "standart-v4" не существует, существуют следующие https://yandex.cloud/ru/docs/compute/concepts/vm-platforms?utm_referrer=https%3A%2F%2Fgithub.com%2Fnetology-code%2Fter-homeworks%2Fissues%2F2. Так же необходимо поменять значения параметров cores на 2 (количество процессоров) и core_fraction (гарантированная доля vCPU) на 20.
![image](https://github.com/user-attachments/assets/3970253c-91cf-4540-bc69-8e326f032b5b)

5. Подключитесь к консоли ВМ через ssh и выполните команду  curl ifconfig.me.

![image](https://github.com/user-attachments/assets/b150f316-5b3f-496b-9373-c6917ab7181b)

6. Ответьте, как в процессе обучения могут пригодиться параметры preemptible = true и core_fraction=5 в параметрах ВМ.
- Параметр preemptible указывает на прерываемое свойство ВМ, т.е. что ВМ будет автоматически быть выключена спустя 24 часов работы, а также в любой момент провайдером. Данный параметр помогает экономить стоймости ВМ.
- Параметр core_fraction указывает на базовую производительность ядра в процентах, так же этот параметр помогает экономить на стоймости ВМ.

# Задание 2. Замените все хардкод-значения для ресурсов yandex_compute_image и yandex_compute_instance на отдельные переменные. К названиям переменных ВМ добавьте в начало префикс vm_web_ . Пример: vm_web_name.
## main.tf: 
```
data "yandex_compute_image" "ubuntu" {
  family = var.vm_web_family
}
resource "yandex_compute_instance" "platform" {
  name        = var.vm_web_name
  platform_id = var.vm_web_platform[0]
  resources {
    cores         = var.vm_web_platform[1]
    memory        = var.vm_web_platform[2]
    core_fraction = var.vm_web_platform[3]
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
    }
  }
  scheduling_policy {
    preemptible = var.vm_web_platform[4]
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat       = var.vm_web_platform[5]
  }

  metadata = {
    serial-port-enable = 1
    ssh-keys           = "ubuntu:${var.vms_ssh_root_key}"
  }

}
```
## varibals.tf:
```
variable "vm_web_family" {
  type        = string
  default     = "ubuntu-2004-lts"
  description = "yandex_compute_image"
}

variable "vm_web_name" {
  type        = string
  default     = "netology-develop-platform-web"
  description = "yandex_compute_instance"
}

variable "vm_web_platform" {
  type        = tuple([ string, number, number, number, bool, bool ])
  default     = ["standard-v3", 2, 1, 20, true, true]
  description = "yandex_compute_instance"
}
```
![image](https://github.com/user-attachments/assets/076c1528-d195-4eca-8bf4-8ae2b2d4a1a9)

# Задание 3.
https://github.com/starky29/terra-2/blob/main/vms_platform.tf
## main.cf:
```
resource "yandex_vpc_network" "develop_db" {
  name = var.vm_db_vpc_name
}
resource "yandex_vpc_subnet" "develop_db" {
  name           = var.vm_db_vpc_name
  zone           = var.zone_b
  network_id     = yandex_vpc_network.develop_db.id
  v4_cidr_blocks = var.default_cidr
}

resource "yandex_compute_instance" "platform_db" {
  name        = var.vm_db_name
  platform_id = var.vm_db_platform[0]
  zone = var.zone_b
  resources {
    cores         = var.vm_db_platform[1]
    memory        = var.vm_db_platform[2]
    core_fraction = var.vm_db_platform[3]
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
    }
  }
  scheduling_policy {
    preemptible = var.vm_db_platform[4]
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.develop_db.id
    nat       = var.vm_db_platform[5]
  }

  metadata = {
    serial-port-enable = 1
    ssh-keys           = "ubuntu:${var.vms_ssh_root_key}"
    
  }

}
```
![image](https://github.com/user-attachments/assets/294e45ea-d2c8-4894-bba8-99476cd4e828)

# Задание 4. Объявите в файле outputs.tf один output , содержащий: instance_name, external_ip, fqdn для каждой из ВМ в удобном лично для вас формате.(без хардкода!!!)

https://github.com/starky29/terra-2/blob/main/output.tf


![image](https://github.com/user-attachments/assets/02983352-6b3e-4b68-bb6d-4d157b9ec836)

# Задание 5. Локальные переменные
https://github.com/starky29/terra-2/blob/main/locals.tf

![image](https://github.com/user-attachments/assets/5e99313d-1552-4134-8348-3edba6ba92ed)

# Задание 6. 
- Вместо использования трёх переменных ".._cores",".._memory",".._core_fraction" в блоке resources {...}, объедините их в единую map-переменную vms_resources и внутри неё конфиги обеих ВМ в виде вложенного map(object).
Переменнная resources
```
variable "vms_resources" {
    type    = map(object({
        platform_id = string
        cores   =   number
        memory  =   number
        core_fraction   =   number
        preemptible = bool
        nat = bool
    }))
    default = {
      "web" = {
        platform_id = "standard-v3"
        cores   =  2
        memory  =  1
        core_fraction   =   20
        preemptible = true
        nat = true
      }
      "db" = {
        platform_id = "standard-v3"
        cores   =  2
        memory  =  2
        core_fraction   =   20
        preemptible = true
        nat = true
      }
    }
    description = "vms resources"
}
```
- Создайте и используйте отдельную map(object) переменную для блока metadata, она должна быть общая для всех ваших ВМ.
Переменная metadata
```
variable "vms_metadata" {
  type = map(string)
  default = {
    "serial-port-enable" = "1"
    "ssh-keys"           = "ubuntu:ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPPRCaLLLFRjPylJ+2X+wh42P6rdIsX5nO1kmsDdJqWE starkov_aa@fedora"
  }
  description = "Metadata for VMs"
}
```
