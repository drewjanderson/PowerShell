# This function is intended to be used to check the last boot time of a system. I picked this up
# a while ago and don't recall where I got it. If this is yours or you know where it originated,
# please let me know
Function Get-LastBootTime ($ComputerName) {
    $LastBootUpTime = Get-WmiObject Win32_OperatingSystem -ComputerName $ComputerName | Select-Object -ExpandProperty LastBootUpTime
    [System.Management.ManagementDateTimeConverter]::ToDateTime($LastBootUpTime)
}