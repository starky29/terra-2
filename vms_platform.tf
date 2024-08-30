variable "vm_web_vpc_name" {
  type        = string
  default     = "develop_web"
  description = "VPC network & subnet name"
}

variable "vm_web_family" {
  type        = string
  default     = "ubuntu-2004-lts"
  description = "vm_web"
}

variable "vm_web_name" {
  type        = string
  default     = "netology-develop-platform-web"
  description = "vm_web"
}

variable "vm_web_platform" {
  type        = tuple([ string, number, number, number, bool, bool, bool ])
  default     = ["standard-v3", 2, 1, 20, true, true, true]
  description = "vm_web"
}

variable "vm_db_vpc_name" {
  type        = string
  default     = "develop_db"
  description = "VPC network & subnet name"
}

variable "zone_b" {
  type        = string
  default     = "ru-central1-b"
  description = "zone_b"
}

variable "vm_db_family" {
  type        = string
  default     = "ubuntu-2004-lts"
  description = "vm_db"
}

variable "vm_db_name" {
  type        = string
  default     = "netology-develop-platform-db"
  description = "vm_db"
}

variable "vm_db_platform" {
  type        = tuple([ string, number, number, number, bool, bool, bool ])
  default     = ["standard-v3", 2, 2, 20, true, true, true]
  description = "vm_db"
}
variable "vms_resources" {
    type    = map(object({
        cores   =   number
        memory  =   number
        core_fraction   =   number
    }))
    default = {
      "web" = {
        cores   =  2
        memory  =  1
        core_fraction   =   20
      }
      "db" = {
        cores   =  2
        memory  =  2
        core_fraction   =   20
      }
    }
 
}
