variable "subscription_id" {
  type = string
}

variable "app_role" {
  type    = string
  default = "Management"
}

variable "region" {
  description = "Region to be deployed"
  type        = string
}

variable "env" {
  description = "Environment of the Infrastucture"
  type        = string
}

variable "vm_user" {
  description = "Virtual Machine user for SSH"
  type        = string
}

variable "vm_kp" {
  description = "Public Key Pair of the Virtual Machine"
  type        = string
}

variable "vm_size" {
  description = "Size of the Virtual Machine"
  type        = string
}