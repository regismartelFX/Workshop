resource "azurerm_policy_definition" "this" {
  name                = "Deploy-Diagnostics-Website"
  policy_type         = "Custom"
  mode                = "Indexed"
  display_name        = "Deploy Diagnostic Settings for App Service to Log Analytics workspace"
  management_group_id = var.management_group_id == "" ? null : var.management_group_id

  metadata = <<METADATA
{
  "version": "1.0.0",
  "category": "Monitoring",
  "createdBy": null,
  "createdOn": null,
  "updatedBy": null,
  "updatedOn": null
}
METADATA

  policy_rule = <<POLICY_RULE
{
  "if": {
    "allOf": [
      {
        "field": "type",
        "equals": "Microsoft.Web/sites"
      },
      {
        "value": "[field('kind')]",
        "notContains": "functionapp"
      }
    ]
  },
  "then": {
    "effect": "[parameters('effect')]",
    "details": {
      "type": "Microsoft.Insights/diagnosticSettings",
      "name": "setByPolicy",
      "existenceCondition": {
        "allOf": [
          {
            "field": "Microsoft.Insights/diagnosticSettings/logs.enabled",
            "equals": "true"
          },
          {
            "field": "Microsoft.Insights/diagnosticSettings/metrics.enabled",
            "equals": "true"
          },
          {
            "field": "Microsoft.Insights/diagnosticSettings/workspaceId",
            "equals": "[parameters('logAnalytics')]"
          }
        ]
      },
      "roleDefinitionIds": [
        "/providers/microsoft.authorization/roleDefinitions/749f88d5-cbae-40b8-bcfc-e573ddc772fa",
        "/providers/microsoft.authorization/roleDefinitions/92aaf0da-9dab-42b6-94a3-d43ce8d16293"
      ],
      "deployment": {
        "properties": {
          "mode": "Incremental",
          "template": {
            "$schema": "http://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
            "contentVersion": "1.0.0.0",
            "parameters": {
              "resourceName": {
                "type": "String"
              },
              "logAnalytics": {
                "type": "String"
              },
              "location": {
                "type": "String"
              },
              "profileName": {
                "type": "String"
              },
              "metricsEnabled": {
                "type": "String"
              },
              "logsEnabled": {
                "type": "String"
              }
            },
            "variables": {},
            "resources": [
              {
                "type": "Microsoft.Web/sites/providers/diagnosticSettings",
                "apiVersion": "2017-05-01-preview",
                "name": "[concat(parameters('resourceName'), '/', 'Microsoft.Insights/', parameters('profileName'))]",
                "location": "[parameters('location')]",
                "dependsOn": [],
                "properties": {
                  "workspaceId": "[parameters('logAnalytics')]",
                  "metrics": [
                    {
                      "category": "AllMetrics",
                      "enabled": "[parameters('metricsEnabled')]",
                      "retentionPolicy": {
                        "days": 0,
                        "enabled": false
                      },
                      "timeGrain": null
                    }
                  ],
                  "logs": [
                    {
                      "category": "AppServiceHTTPLogs",
                      "enabled": "[parameters('logsEnabled')]"
                    },
                    {
                      "category": "AppServiceConsoleLogs",
                      "enabled": "[parameters('logsEnabled')]"
                    },
                    {
                      "category": "AppServiceAppLogs",
                      "enabled": "[parameters('logsEnabled')]"
                    },
                    {
                      "category": "AppServiceAuditLogs",
                      "enabled": "[parameters('logsEnabled')]"
                    },
                    {
                      "category": "AppServiceIPSecAuditLogs",
                      "enabled": "[parameters('logsEnabled')]"
                    },
                    {
                      "category": "AppServicePlatformLogs",
                      "enabled": "[parameters('logsEnabled')]"
                    }
                  ]
                }
              }
            ],
            "outputs": {}
          },
          "parameters": {
            "logAnalytics": {
              "value": "[parameters('logAnalytics')]"
            },
            "location": {
              "value": "[field('location')]"
            },
            "resourceName": {
              "value": "[field('name')]"
            },
            "profileName": {
              "value": "[parameters('profileName')]"
            },
            "metricsEnabled": {
              "value": "[parameters('metricsEnabled')]"
            },
            "logsEnabled": {
              "value": "[parameters('logsEnabled')]"
            }
          }
        }
      }
    }
  }
}
POLICY_RULE

  parameters = <<PARAMETERS
{
  "logAnalytics": {
    "type": "String",
    "metadata": {
      "displayName": "Log Analytics workspace",
      "description": "Select Log Analytics workspace from dropdown list. If this workspace is outside of the scope of the assignment you must manually grant 'Log Analytics Contributor' permissions (or similar) to the policy assignment's principal ID.",
      "strongType": "omsWorkspace"
    }
  },
  "effect": {
    "type": "String",
    "metadata": {
      "displayName": "Effect",
      "description": "Enable or disable the execution of the policy"
    },
    "allowedValues": [
      "DeployIfNotExists",
      "Disabled"
    ],
    "defaultValue": "DeployIfNotExists"
  },
  "profileName": {
    "type": "String",
    "metadata": {
      "displayName": "Profile name",
      "description": "The diagnostic settings profile name"
    },
    "defaultValue": "setbypolicy"
  },
  "metricsEnabled": {
    "type": "String",
    "metadata": {
      "displayName": "Enable metrics",
      "description": "Whether to enable metrics stream to the Log Analytics workspace - True or False"
    },
    "allowedValues": [
      "True",
      "False"
    ],
    "defaultValue": "True"
  },
  "logsEnabled": {
    "type": "String",
    "metadata": {
      "displayName": "Enable logs",
      "description": "Whether to enable logs stream to the Log Analytics workspace - True or False"
    },
    "allowedValues": [
      "True",
      "False"
    ],
    "defaultValue": "True"
  }
}
PARAMETERS
}
