$RESTOREDBNAME="ExactrakGlobalHESWISDev_20210608"
$RESOURCEGROUP="Exactrak-HWE-Dev-RG"
$SERVER="avhe-az-dvsql01"
$COPYDBNAME="ExactrakGlobalHESWISDev_20210608"
$NEWDBNAME="ExactrakGlobalHESWISDev_20210608_copy"
$EARLIESTRESTORETIME=((Get-AzSqlDatabaseRestorePoint -ResourceGroupName $RESOURCEGROUP -ServerName $SERVER -DatabaseName $RESTOREDBNAME).EarliestRestoreDate).ToString("yyyy-MM-dd"+"T"+"hh:mm:ss")


# az sql db copy --dest-name $COPYDBNAME --dest-resource-group $TARGETRESOURCEGROUP --dest-server $DESTINATIONSERVER --name $NEWDBNAME --resource-group $RESOURCEGROUP --server $DESTINATIONSERVER
                    ## NEW DB Name Here  # ORIGINAL DB NAME     # RG name                       # Server Name here
az sql db restore --dest-name $NEWDBNAME --name $RESTOREDBNAME --resource-group $RESOURCEGROUP --server $SERVER --time $EARLIESTRESTORETIME
az sql db delete --name $COPYDBNAME --resource-group $RESOURCEGROUP --server $SERVER
az sql db rename --name $NEWDBNAME --new-name $COPYDBNAME --resource-group $RESOURCEGROUP --server $SERVER
az sql db ltr-policy set -g $RESOURCEGROUP -s $SERVER -n $RESTOREDBNAME --weekly-retention "P3M" --monthly-retention "P3M"

