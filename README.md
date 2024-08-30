# terra-2
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
## varibals.tf:
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

![image](https://github.com/user-attachments/assets/076c1528-d195-4eca-8bf4-8ae2b2d4a1a9)

# Задание 3.

