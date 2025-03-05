variable "default_tags" {
  type        = map(any)
  description = "Default tags to be applied to all Azure resources"
  default = {
    "Name"  = "Connectify"
    "Owner" = "AspireTech"
  }
}

variable "namespace" {
  type    = string
  default = "ATC"
}