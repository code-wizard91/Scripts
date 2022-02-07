#!/usr/bin/env bash

echo "Current Subscription \n"
az account show --query [id] --output tsv
az storage account create --location uksouth --name srcstrgacc --resource-group Data-Factory --sku Standard_LRS --kind BlobStorage --access-tier hot
