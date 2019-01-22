# Collects list of information from each AD Domain Controller in the AD forest

Import-Module ActiveDirectory

# Global variables
$credentials = Get-Credential
$objectlist = @()
$todaysdate = Get-Date -UFormat %Y-%m-%d
New-Item -ItemType Directory -Name temp -Path C:\ -ErrorAction SilentlyContinue
$csvpath = "C:\temp\$todaysdate-DomainControlllers.csv"

Write-Host "Building list of Domain Controllers..." -ForegroundColor Cyan
$DCs = (get-adforest).domains | ForEach-Object {(Get-ADDomain $_).Replicadirectoryservers}
Write-Host "Domain Controller list generated." -ForegroundColor Green

foreach ($computer in $DCs) {
    Write-Host "Collecting data from $computer..." -ForegroundColor Cyan
    $info = Get-WmiObject -ComputerName $computer -Class win32_Computersystem -Credential $credentials
    $OS = Get-WmiObject -ComputerName $computer -Class win32_OperatingSystem -Credential $credentials
    $object = New-Object -TypeName psobject -Property @{
        DC = $info.Name
        Domain = $info.Domain
        Manufacturer = $info.Manufacturer
        Model = $info.Model
        OSVersion = $OS.Caption
    }
    $objectlist += $object
}

Write-Host "Exporting data to CSV..." -ForegroundColor Cyan
$objectlist | Sort-Object DC | Export-Csv -Path $csvpath -NoTypeInformation
Write-Host "Domain Controller data exported to $csvpath" -ForegroundColor Green