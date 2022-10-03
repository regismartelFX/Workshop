################################################################################
### Policy assignment parameters
################################################################################

variable "management_group" {
  type = object({
    id   = string
    name = string
  })
  description = "An object that represents the scope on which the policy will be applied."
}

variable "not_scopes" {
  type        = list(string)
  default     = []
  description = "A list of ids of scopes on which the policy will not be applied.  Id to be provided in the form \"/providers/Microsoft.Management/managementGroups/FXINNOVATION\", which doesn't equate the ID displayed in the portal.  Use Get-AzManagementGroup to fetch the Id."
}

variable "description" {
  type        = string
  default     = ""
  description = "A description which should be used for this Policy Assignment."
}

variable "enforce" {
  type        = bool
  default     = true
  description = "Specifies if this Policy should be enforced or not."
}

variable "location" {
  type        = string
  description = "The Azure Region where the Policy Assignment should exist."
}


################################################################################
### Policy parameters
################################################################################
variable "logAnalytics_1" {
  type        = string
  description = "Policy parameter.  Select Log Analytics workspace from dropdown list. If this workspace is outside of the scope of the assignment you must manually grant 'Log Analytics Contributor' permissions (or similar) to the policy assignment's principal ID."
}

variable "listOfImageIdToInclude_windows" {
  type        = set(string)
  default     = []
  description = "Policy parameter.  Example value: '/subscriptions/<subscriptionId>/resourceGroups/YourResourceGroup/providers/Microsoft.Compute/images/ContosoStdImage'."
}

variable "listOfImageIdToInclude_linux" {
  type        = set(string)
  default     = []
  description = "Policy parameter.  Example value: '/subscriptions/<subscriptionId>/resourceGroups/YourResourceGroup/providers/Microsoft.Compute/images/ContosoStdImage'."
}
