# Disables IPv6 on all local network adapters on the target server.

$creds = Get-Credential
$computer = 'targetserver'
$cimsession = New-CimSession -ComputerName $computer -Credential $creds

# Collects adapters and disables the IPv6 option
Get-NetAdapterBinding -ComponentID 'ms_tcpip6' -CimSession $cimsession | Disable-NetAdapterBinding -ComponentID ms_tcpip6 -CimSession $cimsession -PassThru

# Cleans up the cim session
Remove-CimSession -CimSession $cimsession