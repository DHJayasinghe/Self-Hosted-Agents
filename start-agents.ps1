$RESOURCE_GROUP = 'devops-rg'
$INSTANCES=(Get-AzContainerGroup -ResourceGroupName  $RESOURCE_GROUP | Sort-Object -Property Name | Select-Object -Property Name)

$jobArray = New-Object -TypeName System.Collections.ArrayList
# $Job = Start-Job -ScriptBlock {Write-Output 'Hello World'}
# Wait-Job $Job
# Receive-Job $Job

$Hosts = 'Hyper-V-1','Hyper-V-2','Hyper-V-3','Hyper-V-4','Hyper-V-5'
$INSTANCES | ForEach-Object  { 
    $instanceName = $_.Name
    # Write-Host $name
    $job = Start-Job -ScriptBlock {
        $instanceName =$using:instanceName
        Write-Host "Starting container instance: ${instanceName}"
        Start-AzContainerGroup -Name $instanceName -ResourceGroupName $using:RESOURCE_GROUP 
    }
    $null = $jobArray.Add($job)
}
Wait-Job $jobArray
Receive-Job $jobArray
# $jobArray  | ForEach-Object {
#     # Write-Host $_.Name
#     Receive-Job $_.Id
# }


# Measure-Command {Invoke-Command -ScriptBlock { Write-Host 'hello world' } -AsJob -ComputerName localhost}
# $Job = Start-Job -ScriptBlock {
#     Write-Host 'hello world'
# }
# Receive-Job $Job    

# $INSTANCES | ForEach-Object {
#     $instanceName = $_.Name
#     Write-Host "Starting container instance: ${instanceName}"
#     # Start-AzContainerGroup -Name $instanceName -ResourceGroupName $RESOURCE_GROUP 
# } 