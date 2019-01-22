# Pulls ODBC Driver version information from a server via CIM session

Import-Module Wdac

$admincreds = Get-Credential

# Establish CIM session
$cim = New-CimSession -Credential $admincreds -ComputerName server1.blackmesaresearch.org

# Collect driver versions as well as additional attributes
$driverversions = Get-OdbcDriver -CimSession $cim | Select-Object Name, Platform, @{name="DriverODBCVer";Expression={$_.attribute.driverodbcver}}, @{name="APILevel";Expression={$_.attribute.APILevel}}, @{name="SQLLevel";Expression={$_.attribute.SQLLevel}}

# Export to CSV
$driverversions | Export-Csv -Path C:\temp\ODBC_DriverInfo.csv -NoTypeInformation

# Cleanup
Remove-CimSession -CimSession $cim -Confirm:$false
Clear-Variable -Name admincreds -Confirm:$false
Remove-Module Wdac -Force -Confirm:$false