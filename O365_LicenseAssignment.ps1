
<#PSScriptInfo

.VERSION 1.0.2

.GUID 9fb9489c-2584-4b71-8122-abd3d9d9d95b

.AUTHOR Andrew Anderson - Twitter @drewjanderson

.COMPANYNAME AndersonTech

.COPYRIGHT 

.TAGS MSOL Office365 Licenses

.LICENSEURI https://github.com/vDrewA/PowerShell/blob/master/LICENSE

.PROJECTURI 

.ICONURI 

.EXTERNALMODULEDEPENDENCIES Microsoft Online Services Sign-In Assistant for IT Professionals RTW, AzureActiveDirectory

.REQUIREDSCRIPTS 

.EXTERNALSCRIPTDEPENDENCIES

.RELEASENOTES
 Included External Module Dependencies in metadata.


#>

<# 

.DESCRIPTION 
 This script will export a list of all Microsoft Online/Office365 users along with their assigned license SKUs. 

#> 

# Import the Azure Active Directory module into the current PS session
Import-Module Azure

# Opens a Save File dialog box filtered to CSV file types
Function Get-SaveFilePath($initialDirectory){ 
    [System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms") | Out-Null
    $SaveFileDialog = New-Object System.Windows.Forms.SaveFileDialog
    $SaveFileDialog.initialDirectory = $initialDirectory
    $SaveFileDialog.filter = "CSV Files (*.csv) | *.csv"
    $SaveFileDialog.ShowDialog() | Out-Null
    Return $SaveFileDialog.FileName
}

# Prompts user to enter Microsoft Online credentials
$Msolcredential = Get-Credential -Message "Enter your Microsoft Online credentials with username in <username>@<domain> format."

# Sets the Save File path for the CSV export file using C:\ as the initial directory
$filepath = Get-SaveFilePath -initialDirectory C:\

# Connects to Microsoft Online using the credentials that were entered at the prompt
Connect-MsolService -Credential $Msolcredential

# Gathers all Microsoft Online users that have any licenses assigned and pulls their name and the license SKU(s) they have assigned to their account, renames the column headings, and exports it to CSV using the selected location
Get-MsolUser -All | Where-Object {$_.isLicensed -eq $true} | Select-Object @{expression={$_.DisplayName}; label='Name'},@{expression={$_.Licenses.AccountSkuId}; label='License(s) Assigned'} | Export-Csv -Path $filepath -NoTypeInformation

# Remove the Azure Active Directory module from the session
Remove-Module -Name Azure -Confirm:$false