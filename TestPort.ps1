# Define input and output files
$ServerList = "C:\temp\CheckPortStatus.txt"   # Text file with one server per line
$OutputFile = "C:\temp\PortStatusResult.csv"

# Define the port you want to check
$Port = 5985   # Example: WinRM port

# Create an empty array to store results
$Results = @()

# Read servers from file
$Servers = Get-Content $ServerList

foreach ($Server in $Servers) {
    try {
        # Try to open TCP connection
        $Connection = Test-NetConnection -ComputerName $Server -Port $Port -WarningAction SilentlyContinue

        $Results += [PSCustomObject]@{
            Server   = $Server
            Port     = $Port
            Status   = if ($Connection.TcpTestSucceeded) { "Open" } else { "Closed" }
        }
    }
    catch {
        $Results += [PSCustomObject]@{
            Server   = $Server
            Port     = $Port
            Status   = "Error"
        }
    }
}

# Export results to CSV
$Results | Export-Csv -Path $OutputFile -NoTypeInformation

Write-Host "Port status check completed. Results saved to $OutputFile"
