$servers = @("dev1d2cldapp159.info.corp")

# Grafana download URL (latest Windows .zip)
$grafanaUrl = "https://github.com/grafana/alloy/releases/download/v1.11.3/alloy-installer-windows-amd64.exe"
$zipFile = "C:\Temp\grafana.zip"
$installPath = "C:\Grafana"

# Loop through each server
foreach ($server in $servers) {
    Write-Host "Installing Grafana on $server..." -ForegroundColor Cyan

    Invoke-Command -ComputerName $server -ScriptBlock {
        param($grafanaUrl, $zipFile, $installPath)

        # Create temp folder
        New-Item -ItemType Directory -Path (Split-Path $zipFile) -Force | Out-Null

        # Download Grafana
        Invoke-WebRequest -Uri $grafanaUrl -OutFile $zipFile

        # Extract files
        Expand-Archive -Path $zipFile -DestinationPath $installPath -Force

        # Optional: Install as Windows service using NSSM
        $nssmUrl = "https://nssm.cc/release/nssm-2.24.zip"
        $nssmZip = "C:\Temp\nssm.zip"
        Invoke-WebRequest -Uri $nssmUrl -OutFile $nssmZip
        Expand-Archive -Path $nssmZip -DestinationPath "C:\nssm" -Force

        & "C:\nssm\win64\nssm.exe" install Grafana "$installPath\bin\grafana-server.exe"
        & "C:\nssm\win64\nssm.exe" set Grafana AppDirectory "$installPath"
        & "C:\nssm\win64\nssm.exe" start Grafana

        Write-Host "Grafana installed and service started on $env:COMPUTERNAME" -ForegroundColor Green
    } -ArgumentList $grafanaUrl, $zipFile, $installPath
}
