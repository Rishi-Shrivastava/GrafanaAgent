# Prompt for service account credentials
$Cred = Get-Credential -Message "Enter service account credentials"

# Paths
$ServerListPath = "C:\Temp\PlaceConfigAlloyToTarget_ServersList.txt"
$LocalConfigFile = "C:\Program Files\GrafanaLabs\Alloy\config.alloy"   # Path to config file on local server
$RemoteConfigPath = "C:\Program Files\GrafanaLabs\Alloy\config.alloy"
$OutputReport = "C:\Temp\AlloyDeploymentReport.csv"

$Results = @()
$Servers = Get-Content $ServerListPath

foreach ($Server in $Servers) {
    Write-Host "Processing $Server..."
    try {
        # Create a remote session with service account
        $Session = New-PSSession -ComputerName $Server -Credential $Cred

        # Copy file into remote server via session
        Copy-Item -Path $LocalConfigFile -Destination $RemoteConfigPath -ToSession $Session -Force

        # Restart Alloy service remotely
        Invoke-Command -Session $Session -ScriptBlock {
            Restart-Service -Name "alloy" -Force
        }

        # Close session
        Remove-PSSession $Session

        $Results += [PSCustomObject]@{
            Server = $Server
            Status = "Success"
            Action = "Config copied and service restarted"
        }
    }
    catch {
        $Results += [PSCustomObject]@{
            Server = $Server
            Status = "Failed"
            Action = $_.Exception.Message
        }
    }
}

# Export results
$Results | Export-Csv -Path $OutputReport -NoTypeInformation
Write-Host "Deployment completed. Report saved to $OutputReport"
