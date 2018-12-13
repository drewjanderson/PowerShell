# Populate this variable with the NetAdapter Name for the NIC you wish to update
$adaptername = 'ADAPTERNAME'
$jumboframevalue = 9014
$standardframevalue = 1514

# Sets the MTU to the required Windows Server MTU value for Jumbo Frame
Set-NetAdapterAdvancedProperty -Name $adaptername -RegistryKeyword '*JumboPacket' -RegistryValue $jumboframevalue

# Sets the MTU to the required Windows Server MTU value for Standard Frame
Set-NetAdapterAdvancedProperty -Name $adaptername -RegistryKeyword '*JumboPacket' -RegistryValue $standardframevalue

# Run this to verify
Get-NetAdapterAdvancedProperty -Name $adaptername | Where-Object {$_.DisplayName -eq 'Jumbo Packet'}