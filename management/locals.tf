locals {
  # Defaults
  env          = upper(var.env)
  namespace    = module.common.namespace
  default_tags = merge(module.common.default_tags, { "AppRole" : var.app_role, "Environment" : upper(var.env), "Project" : local.namespace })
  name_prefix  = "${local.namespace}-${local.env}"

  # Naming Conventions
  resource_group = "${local.name_prefix}-RESOURCE-GROUP"
  vnet           = "${local.name_prefix}-VNET"
  subnet         = "${local.name_prefix}-SUBNET"
  pip            = "${local.name_prefix}-PIP"
  nic            = "${local.name_prefix}-NIC"
  nsg            = "${local.name_prefix}-NSG"
  vm             = "${local.name_prefix}-VM"
}