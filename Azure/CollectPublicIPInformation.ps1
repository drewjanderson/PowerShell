# Author: Drew Anderson
# Twitter: @drewjanderson
# Description: This script collects Public IP Address information from all accessible subscriptions
#              within a single Azure Active Directory tenant. The exported information includes the
#              Name, Resource Group, Type (Basic/Standard), and the network adapter the address is
#              associated with.
#
# Dependencies: Az PowerShell Module

param(
    [Parameter(Mandatory=$true, HelpMessage='Azure Tenant ID')]
    [string]
    $tenantID,

    [Parameter(Mandatory=$true, HelpMessage='Enter full path to save the export file as CSV')]
    [string]
    $reportpath
)

# Sets date format to YYYY-MM-DD
$date = Get-Date -UFormat "%Y-%m-%d"

# Prompts for interactive login
Connect-AzAccount

# Gathers Enabled subscriptions and sorts them alphabetically
$subscriptions = Get-AzSubscription -TenantId $tenantID | Where-Object {$_.State -eq "Enabled"} | Select-Object Name | Sort-Object Name

# Collects public IP info from each enabled subscription
$staticIPlist = @()
foreach ($sub in $subscriptions.Name) {
    Select-AzSubscription -SubscriptionName $sub
    $ipinfo = Get-AzPublicIpAddress | Select-Object Name, @{name="ResourceGroup";Expression={$_.ResourceGroupName}}, @{name="Type";Expression={$_.sku.Name}}, @{name="AssociatedWith";Expression={$_.ipconfiguration.id}}
    $staticIPlist += $ipinfo
}

# Export list to CSV
$staticIPlist | Export-Csv -Path "$reportpath\$date-PublicIPAddressInfo.csv" -NoTypeInformation
