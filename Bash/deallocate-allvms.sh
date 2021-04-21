!#!/usr/bin/ bash
echo "Deallocating All VM's"
az vm deallocate --ids $(az vm list --query "[].id" -o tsv)