variable "name" {
  type = string
}

variable "db_name" {
  type = string
}

variable "db_user" {
  type = string
}

variable "db_pass" {
  type = string
}

variable "security_groups" {
  type = list(string)
}

variable "db_name_final_snapshot" {
  type = string
  default = "final_snapshot"
}