## Setting the variables for NON PROD
ENVIRONMENT="NonProd"
MANAGEMENTGRP_NON_PROD="ac52f73c-fd1a-4a9a-8e7a-4a248f3139e1"
BACKEND_CONFIG_NON_PROD_RG='"resource_group_name=p151clorgptfsta"'
BACKEND_CONFIG_NON_PROD_STRG_ACC='"storage_account_name=p151clostotfsta"'
BACKEND_CONFIG_NON_PROD_STRG_CONTAINER_NAME='"container_name=azure-policy"'
BACKEND_CONFIG_NON_PROD_STRG_KEY='"key=sql/dev/policy.tfstate"'

## Importing Terraform State Configuration Backend for Non-Prod

terraform init -backend-config=$BACKEND_CONFIG_NON_PROD_RG -backend-config=$BACKEND_CONFIG_NON_PROD_STRG_ACC -backend-config=$BACKEND_CONFIG_NON_PROD_STRG_CONTAINER_NAME -backend-config=$BACKEND_CONFIG_NON_PROD_STRG_KEY

# Storing the ID's for the Initiative, assignment and policices here for NON-PROD

SQL_INITIATIVE_ID=$(az policy set-definition show --name 4dc487ff-b62b-45b3-b409-3ed81b2fb6c0 --management-group $MANAGEMENTGRP_NON_PROD | jq .id)
SQL_DEPLOY_SYSTEMID_POLICY_ID=$(az policy definition show --name e22505c7-6728-487c-adc9-e04f6ba8cf55 --management-group $MANAGEMENTGRP_NON_PROD | jq .id)
SQL_DEPLOY_AUDITING_POLICY_ID=$(az policy definition show --name e22505c7-6728-487c-adc9-e04f6ba8cf46 --management-group $MANAGEMENTGRP_NON_PROD | jq .id)
SQL_DEPLOY_TDE_POLICY_ID=$(az policy definition show --name 1b3909b1-f2c5-4303-8b17-d8add3d66ebe --management-group $MANAGEMENTGRP_NON_PROD | jq .id)
SQL_DEPLOY_VNET_ENDPOINT_POLICY_ID=$(az policy definition show --name ae5d2f14-d830-42b6-9899-df6cfe9c71a3 --management-group $MANAGEMENTGRP_NON_PROD | jq .id)
SQL_DEPLOY_AZUREAD_ADMIN_POLICY_ID=$(az policy definition show --name 1f314764-cb73-4fc9-b863-8eca98ac36e9 --management-group $MANAGEMENTGRP_NON_PROD | jq .id)
SQL_DEPLOY_DATABASE_TDE_POLICY_ID=$(az policy definition show --name 86a912f6-9a06-4e26-b447-11b16ba8659f --management-group $MANAGEMENTGRP_NON_PROD | jq .id)
SQL_POLICY_ASSIGNMENT_ID_NON_PROD=$(az policy assignment show --name b91f05f56c854b9e9011bf19 --scope /providers/Microsoft.Management/managementGroups/$MANAGEMENTGRP_NON_PROD | jq .id)

## Double check the name for the policy below, Not sure if it is called "sql-server-deny-firewall-rules" in NonPROD
SQL_SERVER_DENY_POLICY_ID=$(az policy definition show --name sql-server-deny-firewall-rules --management-group $MANAGEMENTGRP_NON_PROD | jq .id)

## Importing Initiative state from NonProd

terraform import 'module.policy.azurerm_policy_set_definition.definition' $SQL_INITIATIVE_ID

## Importing Policies within the initiative

terraform import 'module.policy.azurerm_policy_definition.sql_server_deny_firewall_rules' $SQL_SERVER_DENY_POLICY_ID
terraform import 'module.policy.sql_server_deploy_system_identity' SQL_DEPLOY_SYSTEMID_POLICY_ID
terraform import 'module.policy.sql_server_deploy_auditing' $SQL_DEPLOY_AUDITING_POLICY_ID
terraform import 'module.policy.sql_server_deploy_tde' $SQL_DEPLOY_TDE_POLICY_ID
terraform import 'data.sql_vnet_endpoint_policy' $SQL_DEPLOY_VNET_ENDPOINT_POLICY_ID
terraform import 'data.sql_azuread_admin_policy' $SQL_DEPLOY_AZUREAD_ADMIN_POLICY_ID
terraform import 'data.sql_deploy_database_tde_policy' $SQL_DEPLOY_DATABASE_TDE_POLICY_ID

## Importing Policy Assignment for NON PROD

terraform import 'module.policy.azurerm_policy_assignment.assignment' $SQL_POLICY_ASSIGNMENT_ID_NON_PROD
