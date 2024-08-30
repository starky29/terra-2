# terra-2
Задание 1.
4. Инициализируйте проект, выполните код. Исправьте намеренно допущенные синтаксические ошибки. Ищите внимательно, посимвольно. Ответьте, в чём заключается их суть.
Ошибки заключались в блоке resource "yandex_compute_instance" "platform". Значения параметра platform_id = "standart-v4" не существует, существуют следующие https://yandex.cloud/ru/docs/compute/concepts/vm-platforms?utm_referrer=https%3A%2F%2Fgithub.com%2Fnetology-code%2Fter-homeworks%2Fissues%2F2. Так же необходимо поменять значения параметров cores на 2 (количество процессоров) и core_fraction (гарантированная доля vCPU) на 20.
![image](https://github.com/user-attachments/assets/3970253c-91cf-4540-bc69-8e326f032b5b)
