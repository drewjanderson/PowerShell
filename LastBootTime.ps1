# This function is intended to be used to check the last boot time of a system. I've had this
# sitting around for some time now and don't recall how much of it I wrote myself and how much
# I found on stackoverflow. Please use this however you wish.
Function Get-LastBootTime ($ComputerName) {
    $LastBootUpTime = Get-WmiObject Win32_OperatingSystem -ComputerName $ComputerName | Select-Object -ExpandProperty LastBootUpTime
    [System.Management.ManagementDateTimeConverter]::ToDateTime($LastBootUpTime)
}