
<#PSScriptInfo

.VERSION 1.0

.GUID b31bac00-cfd7-4c22-b92c-370d0c6ec8d2

.AUTHOR Drew Anderson

.COMPANYNAME 

.COPYRIGHT 

.TAGS 

.LICENSEURI 

.PROJECTURI 

.ICONURI 

.EXTERNALMODULEDEPENDENCIES 

.REQUIREDSCRIPTS 

.EXTERNALSCRIPTDEPENDENCIES 

.RELEASENOTES


#>

<# 

.DESCRIPTION 
 Cleans up shortcuts on the user's desktop as well as the Public Desktop 

#> 


# Collects shortcut files on the user's desktop that is running the script
$myshortcuts = Get-ChildItem -Path $env:HOMEPATH\Desktop | Where-Object {$_.Extension -eq ".lnk"}

# Removes the shortcuts located on the user's desktop
Remove-Item $myshortcuts.FullName -Force -Confirm:$false

# Collects shortcut files on Public's desktop
$publicshortcuts = Get-ChildItem -Path $env:PUBLIC\Desktop | Where-Object {$_.Extension -eq ".lnk"}

# Removes the shortcuts located on Public's desktop
Remove-Item $publicshortcuts.FullName -Force -Confirm:$false