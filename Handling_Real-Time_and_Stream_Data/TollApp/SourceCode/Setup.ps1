$VerbosePreference ="SilentlyContinue"
$region = "West Europe"
$uniqueSuffix = Get-Random -Maximum 9999999999
[Environment]::CurrentDirectory = $PSScriptRoot
$ErrorActionPreference  = 'Stop'

# Check Azure account
$acc = Get-AzureAccount
if (!$acc)
{
	Add-AzureAccount
}

# If there are multiple subscriptions we will need to select one
$subscriptions = Get-AzureSubscription
if ($subscriptions.GetType().IsArray)
{
	Write-Host "Multiple subscriptions found:"  -ForegroundColor Yellow
	$subscriptions | select SubscriptionName
	Write-Host "There are mutiple subscriptions found for your account. Please type the name of the subscription you want to use:" -ForegroundColor Yellow

	$subscriptinName = Read-Host "Subscription Name"
	Select-AzureSubscription -SubscriptionName $subscriptinName
}

# Setup Event Hubs
Write-Host "Create Service Bus namespace and Event Hubs" -ForegroundColor White
$entryEvenHub = "entry"
$exitEvenHub = "exit"
$eventHubs = @($entryEvenHub, $exitEvenHub)

$nsMgrType = [System.Reflection.Assembly]::LoadFrom($PSScriptRoot +"\Microsoft.ServiceBus.dll").GetType("Microsoft.ServiceBus.NamespaceManager")
$nsName = "TollData" + $uniqueSuffix
$ns = New-AzureSBNamespace -Name $nsName -Location $region -CreateACSNamespace $true
Write-Host ("Created Service Bus namespace $nsName")  -ForegroundColor Green
$nsMgr = $nsMgrType::CreateFromConnectionString($ns.ConnectionString)
 
ForEach ($ehName in $eventHubs) 
{ 
	$eh = $nsMgr.CreateEventHubIfNotExists($ehName)
	Write-Host ("Created Event Hub: $ehName") -ForegroundColor Green
}

# Setup Azure SQL Database
Write-Host "Create Azure Sql Database and tables" -ForegroundColor White

$sqlUser = "tolladmin"
$sqlPwd = "123toll!"
$dbName = "TollDataDB"

$svr = New-AzureSqlDatabaseServer -location $region -AdministratorLogin $sqlUser -AdministratorLoginPassword $sqlPwd
$svrName = $svr.ServerName
$sqlServerFqdn = "$svrName.database.windows.net"
Write-Host "Created Sql Server $sqlServerFqdn" -ForegroundColor Green

$rule = New-AzureSqlDatabaseServerFirewallRule -ServerName $svrName -RuleName "all" -StartIPAddress "0.0.0.0" -EndIPAddress "255.255.255.255"
$svrCredential = new-object System.Management.Automation.PSCredential($sqlUser, ($sqlPwd  | ConvertTo-SecureString -asPlainText -Force))
$ctx = $svr | New-AzureSqlDatabaseServerContext -Credential $svrCredential 
$db = New-AzureSqlDatabase $ctx -DatabaseName $dbName 
Write-Host "Created Sql Database: $dbName" -ForegroundColor Green

# Create Sql tables
$sqlConnString = "Server=tcp:$sqlServerFqdn,1433;Database=$dbName;Uid=$sqlUser@$svrName;Pwd=$sqlPwd;Encrypt=yes;Connection Timeout=30;"
$sqlConn= New-Object System.Data.SqlClient.SqlConnection($sqlConnString)
$sqlConn.Open()

$cmdText = [System.IO.File]::ReadAllText("$PSScriptRoot\\SqlScripts\\CreateTables.sql")
$sqlCmd= New-Object System.Data.SqlClient.SqlCommand($cmdText,$sqlConn)
$cmdResult = $sqlCmd.ExecuteNonQuery()
$sqlConn.Close()
Write-Host "Created Sql tables" -ForegroundColor Green

# Setup storage account
$containerName = "tolldata"
Write-Host "Create storage account and upload reference data file" -ForegroundColor White
$storageAccountName = "tolldata" + $uniqueSuffix
$result = New-AzureStorageAccount -StorageAccountName $storageAccountName -Location $region
Write-Host "Created storage account $storageAccountName" -ForegroundColor Green
$storageKeys = Get-AzureStorageKey -StorageAccountName $storageAccountName

$storageContext = New-AzureStorageContext -StorageAccountName $storageAccountName -StorageAccountKey $storageKeys.Primary
$container = New-AzureStorageContainer -Name $containerName -Context $storageContext
$copyResult = Set-AzureStorageBlobContent -file ($PSScriptRoot + "\\Data\\Registration.csv") -Container tolldata -Blob "registration.csv" -Context $storageContext
Write-Host "Uploaded reference data file" -ForegroundColor Green

# Run load generator
Write-Host "Start generating events" -ForegroundColor White
$tollAppType = [System.Reflection.Assembly]::LoadFrom($PSScriptRoot +"\\TollApp.exe").GetType("TollApp.Program")
$tollAppType::SendData($ns.ConnectionString, $entryEvenHub, $exitEvenHub, $true)