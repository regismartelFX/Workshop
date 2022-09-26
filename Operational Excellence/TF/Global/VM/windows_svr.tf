module "windows_svr" {
  source = "./modules/windows_virtual_machine"
  providers = {
    azurerm = azurerm.sandbox
  }

  quantity                            = 2
  seed                                = 1
  descriptive_context                 = module.info.descriptive_context
  environment                         = module.info.sandbox.short_name
  location                            = module.info.primary_region.name
  stdiag_resource_group_name          = data.terraform_remote_state.core.outputs.core_resource_group_name
  stdiag_name                         = azurerm_storage_account.stdiag.name
  core_resource_group_name            = data.terraform_remote_state.core.outputs.core_resource_group_name
  core_key_vault_name                 = "kvdemoccpkn7s0"
  core_key_vault_admin_secret_name    = "default-vm-admin-account-name"
  core_key_vault_adminpwd_secret_name = "default-vm-password"
  core_virtual_network_name           = "vnet-intactoperationalexcellence-p01"
  core_subnet_name                    = "snet-intact"
  core_log_analytics_workspace_name   = "log-demo-p01"
  size                                = module.info.windows_svr_size
  source_image_reference              = module.info.windows_svr_source_image_reference
  tags = {
    BackupPolicy   = "DEMO-35d-12m-7y"
    PatchingPolicy = "Windows Group A"
  }
}


# module "windows_svr_sql" {
#   source = "./modules/windows_virtual_machine"

#   quantity                            = 1
#   seed                                = 3
#   descriptive_context                 = "demosql"
#   environment                         = module.info.sandbox.short_name
#   location                            = module.info.primary_region.name
#   stdiag_name                         = stdiag.name
#   core_resource_group_name            = "rg-intactoperationalexcellence-p01"
#   core_key_vault_name                 = "kvdemoccpkn7s0"
#   core_key_vault_admin_secret_name    = "default-vm-admin-account-name"
#   core_key_vault_adminpwd_secret_name = "default-vm-password"
#   core_virtual_network_name           = "vnet-intactoperationalexcellence-p01"
#   core_subnet_name                    = "snet-intact"
#   core_log_analytics_workspace_name   = "log-demo-p01"
#   size                                = "Standard_B4ms"
#   source_image_reference              = module.info.windows_svr_source_image_reference
#   tags = {
#     BackupPolicy   = "DEMO-35d-12m-7y"
#     PatchingPolicy = "Windows Group B"
#   }
# }





