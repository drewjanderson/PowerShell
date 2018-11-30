<# 
.DESCRIPTION 
 This script removes VMware VM snapshots that are older than the provided value.
#> 

[CmdletBinding()]
Param(
    [Parameter(Mandatory=$true,HelpMessage='Enter number of days for the oldest snapshot to be kept.')]
    [string]$DeleteOlderThan,

    [Parameter(Mandatory=$true,HelpMessage='Enter your vCenter server name')]
    [string]$VIServer
)

# Imports PowerCLI Module
Import-Module VMware.VimAutomation.Core

# Connects to the vCenter or ESXi servers
Connect-VIServer $VIServer

# Collects VM snapshot information for all VMs where the snapshots are older than days specified
$snapshots = Get-VM -Server $VIServer | Get-Snapshot | Where-Object {$_.Created -lt (Get-Date).AddDays(-$DeleteOlderThan)}

# Removes snapshots older than days specified
$snapshots | Remove-Snapshot -RemoveChildren -RunAsync -Confirm:$false

# Disconnects from the connected vCenter or ESXi servers
Disconnect-VIServer $VIServer -Confirm:$false

# Unloads the PowerCLI module
Remove-Module VMware.VimAutomation.Core