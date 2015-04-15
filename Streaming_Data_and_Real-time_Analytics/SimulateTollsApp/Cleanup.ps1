#Cleanup Service Bus namespaces

Write-Host "WARNING: This script is going to delete resources that match resource names used in the lab. Please carefully review names of the resources before confirming delete operation" -ForegroundColor Yellow
Write-Host "Remove Service Bus namespaces starting with 'TollData'"
Get-AzureSBNamespace | Where-Object {$_.Name -like '*TollData*'} | Remove-AzureSBNamespace -Confirm

Write-Host "Remove Azure SQL servers with Administrator Login 'tolladmin'"
Get-AzureSqlDatabaseServer | Where-Object {$_.AdministratorLogin -eq 'tolladmin'} | Remove-AzureSqlDatabaseServer -Confirm

