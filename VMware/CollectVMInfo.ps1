## TODO
# Add sections to retrieve vCPU and RAM quantities
# Add PowerCLI minimum version check otherwise first step fails

# Load PowerCLI module
Import-Module VMware.VimAutomation.Core -ErrorAction Stop

# Reads in connection & export information
$viserver = Read-Host "Enter vCenter FQDN"
$csvname = Read-Host "Enter CSV file name w/o extension"
$csvdir = "C:\temp"
$csvpath = "$csvdir\$csvname.csv"
$admincreds = Get-Credential -Message "Username must be domain\username format"

# Establishes connection to vCenter server
Connect-VIServer -Server $viserver -Credential $admincreds -Force -ErrorAction Stop

# Collects VM list from the connected vCenter
Write-Host "Collecting list of all accessible VMs within the vCenter" -ForegroundColor Yellow
$allvms = Get-VM * -ErrorAction Stop
Write-Host "VM list populated" -ForegroundColor Green

# Collects VM information from all collected VMs
Write-Host "Collecting VM information to prepare for export..." -ForegroundColor Yellow
$vminfo = $allvms | Select-Object Name, ResourcePool, PowerState, @{Name="OS Family";Expression={$_.ExtensionData.Guest.guestFamily}}, @{Name="OS Version";Expression={$_.ExtensionData.Guest.GuestFullName}}, @{Name="Guest IP";Expression={$_.guest.IPAddress}}, @{Name="Hostname";Expression={$_.guest.Hostname}}, ProvisionedSpaceGB, UsedSpaceGB, @{Name="VMTools Status";Expression={$_.ExtensionData.Guest.ToolsStatus}}, @{Name="VMTools Version";Expression={$_.ExtensionData.Guest.ToolsVersion}} -ErrorAction Stop
Write-Host "VM information collected." -ForegroundColor Green

# Export collected info to CSV
$vminfo | Export-Csv -Path $csvpath -NoTypeInformation
Write-Host "VM info exported to CSV at $csvpath" -ForegroundColor Green

# Cleanup workspace
Disconnect-VIServer -Server $viserver -Confirm:$false -Force
Remove-Module VMware.VimAutomation.Core -Force -ErrorAction SilentlyContinue
Clear-Variable admincreds

# Opens Explorer window for quick access to CSV export
Invoke-Item $csvdir