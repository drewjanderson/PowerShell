# Collect list of installed Java versions from an input file with system names/FQDNs

$servers = Import-Csv C:\temp\serverlist.csv
$admincreds = Get-Credential

foreach ($server in $servers.hostname) {
    $list = @()
    try {
        $javainstances = Invoke-Command -ComputerName $server -Credential $admincreds -ErrorAction Stop -ScriptBlock {Get-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\* -ErrorAction Continue | Select-Object -Property Publisher, DisplayName, DisplayVersion | Sort-Object -Property Publisher}
        $list += $javainstances
        $list | Export-Csv -Path C:\temp\javainstalls.csv -NoTypeInformation -Append
    }
    catch {
        Write-Host "$server" -Verbose -ErrorAction Continue
    }
}
