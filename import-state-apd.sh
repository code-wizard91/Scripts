## Setting the variables for APD
ENVIRONMENT="Dev"
MANAGEMENTGRP_APD="APD"
BACKEND_CONFIG_APD_RG='"resource_group_name=N049CLOrgpterraformbackend"'
BACKEND_CONFIG_APD_STRG_ACC='"storage_account_name=n049clostoterraform"'
BACKEND_CONFIG_APD_STRG_CONTAINER_NAME='"container_name=azure-policy"'
BACKEND_CONFIG_APD_STRG_KEY='"key=sql/dev/policy.tfstate"'


## Here We are storing the ID's of the (Policy assignment, Initiative, and Policies) inside variables
SQL_INITIATIVE_ID=$(az policy set-definition show --name azure-sql-single-database-$ENVIRONMENT --management-group $MANAGEMENTGRP_APD | jq .id)
SQL_SERVER_DENY_POLICY_ID=$(az policy definition show --name sql-server-deny-firewall-rules-$ENVIRONMENT --management-group $MANAGEMENTGRP_APD | jq .id)
SQL_DEPLOY_SYSTEMID_POLICY_ID=$(az policy definition show --name sql-server-deploy-system-identity-$ENVIRONMENT --management-group $MANAGEMENTGRP_APD | jq .id)
SQL_DEPLOY_AUDITING_POLICY_ID=$(az policy definition show --name a0264f39-c818-4b23-8876-2b2c21a6f944 --management-group $MANAGEMENTGRP_APD | jq .id)
SQL_DEPLOY_TDE_POLICY_ID=$(az policy definition show --name apply-tde-using-customer-managed-keys-$ENVIRONMENT --management-group $MANAGEMENTGRP_APD | jq .id)
SQL_DEPLOY_VNET_ENDPOINT_POLICY_ID=$(az policy definition show --name 28b0b1e5-17ba-4963-a7a4-5a1ab4400a0b --management-group $MANAGEMENTGRP_APD | jq .id)
SQL_DEPLOY_AZUREAD_ADMIN_POLICY_ID=$(az policy definition show --name 1f314764-cb73-4fc9-b863-8eca98ac36e9 --management-group $MANAGEMENTGRP_APD | jq .id)
SQL_DEPLOY_DATABASE_TDE_POLICY_ID=$(az policy definition show --name 86a912f6-9a06-4e26-b447-11b16ba8659f --management-group $MANAGEMENTGRP_APD | jq .id)
SQL_POLICY_ASSIGNMENT_ID_APD=$(az policy assignment show --name sql-db-Dev --scope /providers/Microsoft.Management/managementGroups/$MANAGEMENTGRP_APD | jq .id)


## Importing State Configuration Backend for APD

terraform init -backend-config=$BACKEND_CONFIG_APD_RG -backend-config=$BACKEND_CONFIG_APD_STRG_ACC -backend-config=$BACKEND_CONFIG_APD_STRG_CONTAINER_NAME -backend-config=$BACKEND_CONFIG_APD_STRG_KEY

## Importing Initiative state from APD

terraform import 'module.policy.azurerm_policy_set_definition.definition' $SQL_INITIATIVE_ID

## Importing Policies within the initiative

terraform import 'module.policy.azurerm_policy_definition.sql_server_deny_firewall_rules' $SQL_SERVER_DENY_POLICY_ID
terraform import 'module.policy.sql_server_deploy_system_identity' SQL_DEPLOY_SYSTEMID_POLICY_ID
terraform import 'module.policy.sql_server_deploy_auditing' $SQL_DEPLOY_AUDITING_POLICY_ID
terraform import 'module.policy.sql_server_deploy_tde' $SQL_DEPLOY_TDE_POLICY_ID
terraform import 'data.sql_vnet_endpoint_policy' $SQL_DEPLOY_VNET_ENDPOINT_POLICY_ID
terraform import 'data.sql_azuread_admin_policy' $SQL_DEPLOY_AZUREAD_ADMIN_POLICY_ID
terraform import 'data.sql_deploy_database_tde_policy' $SQL_DEPLOY_DATABASE_TDE_POLICY_ID

## Importing Policy Assignment for APD

terraform import 'module.policy.azurerm_policy_assignment.assignment' $SQL_POLICY_ASSIGNMENT_ID_APD
