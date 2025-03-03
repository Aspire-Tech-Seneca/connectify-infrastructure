locals {
  # Defaults
  env            = upper(var.env)
  namespace      = module.common.namespace
  default_tags   = merge(module.common.default_tags, { "AppRole" : var.app_role, "Environment" : upper(var.env), "Project" : local.namespace })
  name_prefix    = "${local.namespace}-${local.env}"
  name_prefix_an = "${local.namespace}${local.env}" #Alpha Numeric

  # Resource Naming Conventions
  resource_group    = "${local.name_prefix}-RESOURCE-GROUP"
  storage_account   = lower("${local.name_prefix_an}storageaccount")
  storage_container = lower("${local.name_prefix_an}storagecontainer")
  vnet              = "${local.name_prefix}-VNET"
  subnet            = "${local.name_prefix}-SUBNET"
  pip               = "${local.name_prefix}-PIP"
  nic               = "${local.name_prefix}-NIC"
  nsg               = "${local.name_prefix}-NSG"
  vm                = "${local.name_prefix}-VM"
  atc_acr           = lower("${local.name_prefix_an}acr")

  #
  azure_container_repo = "${local.atc_acr}.azurecr.io"
}