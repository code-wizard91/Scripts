#!/bin/bash

ResourceGroup="ali-spring-rg"
Location="uksouth"
AppPlanName="ali-spr231"
AppName="ali-spr-app101"


az group create -l $Location -n $ResourceGroup
az appservice plan create -n $AppPlanName -g $ResourceGroup -l $Location --is-linux --sku F1
az webapp create --name $AppName --resource-group $ResourceGroup --plan $AppPlanName --runtime "JAVA|8-jre8"
