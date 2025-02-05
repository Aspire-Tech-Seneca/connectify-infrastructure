locals {
  namespace = module.common.namespace
  default_tags = merge(module.common.default_tags, { "AppRole" : var.app_role, "Environment" : upper(var.env), "Project" : local.namespace })
  name_prefix  = "${local.namespace}-${var.env}"

  # Naming Conventions
  resource_group            = upper("${local.name_prefix}-resource-group")
  storage_account           = "senecaatcstorageaccount"
  tfstate_storage_container = "atctfstatecontainer"
}