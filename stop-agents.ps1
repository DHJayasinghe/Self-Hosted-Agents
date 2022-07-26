$RESOURCE_GROUP = 'devops-rg'
$INSTANCES=(Get-AzContainerGroup -ResourceGroupName  $RESOURCE_GROUP | Select-Object -Property Name)

$INSTANCES | ForEach-Object {
    $instanceName = $_.Name
    Write-Host "Stopping container instance: ${instanceName}"
    Stop-AzContainerGroup -Name $instanceName -ResourceGroupName $RESOURCE_GROUP 
} 