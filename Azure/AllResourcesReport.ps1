#####################################################################################################
# Author: Drew Anderson                                                                             #
# Description: This script collects information for all resources within an Azure tenant.           #
#                                                                                                   #
# Minimum Access Requirements: Azure Active Directory User role (no elevated AAD RBAC required)     #
#                              Reader IAM role on each subscription                                 #
#                                                                                                   #
# PowerShell Requirements: Windows PowerShell 5.1                                                   #
#                          PowerShell 7.0.0                                                         #
#                          Azure Cloud Shell                                                        #
#                                                                                                   #
# Module Dependencies: Az PowerShell Module                                                         #
#                                                                                                   #
#                      Installation Method:                                                         #
#                      Install-Module -Name Az -Scope CurrentUser                                   #
#                                                                                                   #
#####################################################################################################

param(
    [Parameter(Mandatory=$true, HelpMessage='Azure Tenant ID')]
    [string]
    $tenantID,

    [Parameter(Mandatory=$true, HelpMessage='Enter full path to save the export file as xlsx')]
    [string]
    $reportdirectory
)

# Sets date format to YYYY-MM-DD
$date = Get-Date -UFormat "%Y-%m-%d"

# Creates folder structure
$randomstring = Get-Random
$outputdirectory = "output$randomstring"
$outputdirectorypath = New-Item -Path $reportdirectory -Name $outputdirectory -ItemType Directory -ErrorAction Stop

# Connects to Azure with the Az module
Connect-AzAccount -Tenant $tenantID

# Captures Azure AD and user information for README
$aadinfo = Get-AzADOrganization | Select-Object DisplayName, Id
$aaddisplayname = $aadinfo.DisplayName
$userinfo = Get-AzAccessToken
$metadata = @{
    AzureADTenantName = $aadinfo.DisplayName
    AzureADTenantId = $aadinfo.Id
    DateReported = $date
    User = $userinfo.UserId
}

# Creates README file
$metadatafilepath = "$reportdirectory\$outputdirectory\README.txt"
$metadata | Out-File -FilePath $metadatafilepath

# Gathers Enabled subscriptions and sorts them alphabetically
$subscriptions = Get-AzSubscription -TenantId $tenantID | Where-Object {$_.State -eq "Enabled"} | Select-Object Name | Sort-Object Name

# Collects Azure resource info from each enabled subscription
$resourceinformationlist = @()
foreach ($sub in $subscriptions.Name) {
    # Define subscription to query
    Select-AzSubscription -SubscriptionName $sub
    
    # Capture all resources (including Hidden) for the subscription
    $resourceinfo = Get-AzResource | Sort-Object ResourceType
    
    # After individual resource information is collected push the data into the table to prepare to export information for all queried resources
    $resourceinformationlist += $resourceinfo
}

# Exports resource information to CSV
$reportpath = "$reportdirectory\$outputdirectory\$date-AllResources.csv"
$resourceinformationlist | Export-Csv -Path $reportpath -NoTypeInformation

# Compresses the CSV and README file
Compress-Archive -Path "$reportdirectory\$outputdirectory\*.*" -CompressionLevel Fastest -DestinationPath "$reportdirectory\$aaddisplayname.zip"

# Cleans up and disconnects from Azure
Remove-Item -Path $outputdirectorypath.FullName -Recurse -Force -Confirm:$false
Disconnect-AzAccount -Confirm:$false
