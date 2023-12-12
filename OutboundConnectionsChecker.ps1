# Function to check connections and display information
function CheckConnections {
    # Get the list of processes running on the system
    $processes = Get-Process

    # Initialize an array to store processes with outbound connections
    $botnetProcesses = @()

    # Iterate through each process and check for outbound connections
    foreach ($process in $processes) {
        $connections = @(Get-NetTCPConnection | Where-Object { $_.OwningProcess -eq $process.Id -and $_.State -eq "Established" -and $_.LocalAddress -ne "0.0.0.0" })
        if ($connections.Count -gt 0) {
            $botnetProcesses += $process
            # Get information about the parent process
            $parentProcess = Get-WmiObject -Class Win32_Process -Filter "ProcessId = $($process.Id)" | Select-Object -ExpandProperty ParentProcessId
            $parentProcessName = (Get-Process -Id $parentProcess).Name
            $parentProcessPath = (Get-Process -Id $parentProcess).Path

            Write-Host "`[!] Process $($process.Name) (ID: $($process.Id)) has outbound connections:" -ForegroundColor Yellow
            Write-Host "[-]    Parent process: $($parentProcessName) (ID: $($parentProcess))" -ForegroundColor Cyan
            Write-Host "[-]    Parent process path: $($parentProcessPath)" -ForegroundColor Cyan

            foreach ($connection in $connections) {
                Write-Host "   Local address: $($connection.LocalAddress), Remote address: $($connection.RemoteAddress), Remote port: $($connection.RemotePort)" -ForegroundColor Green

                # Call ipinfo.io to get IP information from the Remote address
                $ipInfo = Invoke-RestMethod -Uri "https://ipinfo.io/$($connection.RemoteAddress)/json"
                Write-Host "   Remote IP information: $($ipInfo.ip), $($ipInfo.city), $($ipInfo.region), $($ipInfo.country)" -ForegroundColor Yellow
                Write-Host "   Country: $($ipInfo.country)"
                Write-Host "   Region/City: $($ipInfo.region)"
                Write-Host "   ISP (Internet Service Provider): $($ipInfo.org)"

                # Use the IPWHOIS service to get more detailed information
                $ipWhoisInfo = Invoke-RestMethod -Uri "https://ipwhois.app/json/$($connection.RemoteAddress)"
                Write-Host "   IP usage type: $($ipWhoisInfo.type)" -ForegroundColor Cyan
            }
        }
    }

    # Check and display the result
    if ($botnetProcesses.Count -gt 0) {
        Write-Host "`nThere are processes with outbound connections, possibly related to IOC:" -ForegroundColor Red
        foreach ($process in $botnetProcesses) {
            Write-Host "   Process: $($process.Name) (ID: $($process.Id))" -ForegroundColor Red
        }
    }
    else {
        Write-Host "`nNo processes with outbound connections found." -ForegroundColor Green
    }
}

# Display the menu
while ($true) {
    Clear-Host  # Clear the screen to refresh the menu
    Write-Host @"
 ██████╗ ███████╗ ██╗   ██╗ ██████╗  ██████╗
 ██╔══██╗██╔════╝███║   ██║██╔═══██╗██╔════╝
 ██████╔╝███████╗╚██║   ██║██║   ██║██║     
 ██╔═══╝ ╚════██║ ██║   ██║██║   ██║██║     
 ██║     ███████║ ██║██╗██║╚██████╔╝╚██████╗
 ╚═╝     ╚══════╝ ╚═╝╚═╝╚═╝ ╚═════╝  ╚═════╝
                                                                                                                                                                              
"@  -ForegroundColor red
Write-Host @"
    By: Longhoangth18 ( V1.0 )
    More: https://github.com/longhoangth18
"@ 

    Write-Host "    ==== Select Mode ====" -ForegroundColor green
    Write-Host "1. Listen Live Mode " -ForegroundColor Yellow
    Write-Host "2. Run One " -ForegroundColor Yellow
    
    # Receive user input
    $choice = Read-Host "Press (1 OR 2)"

    # Process the choice
    switch ($choice) {
        1 {
            # Run the loop
            Write-Host "Live Mode..."
            while ($true) {
                CheckConnections
                Start-Sleep -Seconds 5  # Wait for 5 seconds before checking again
            }
        }
        2 {
            # Run once
            Write-Host "Run One..."
            CheckConnections
        }
        3 {
            # Exit
            Write-Host "Exiting the program." -ForegroundColor Red
            break
        }
        default {
            Write-Host "Invalid choice. Please choose again." -ForegroundColor Yellow
        }
    }
    # Wait for a period before displaying the menu again (e.g., 2 seconds)
    Start-Sleep -Seconds 2
}
