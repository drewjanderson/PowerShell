# Need DESCRIPTION here!

# Imports the PowerCLI module
Import-Module VMware.VimAutomation.Core

# Connects to either the vCenter or ESXi server that you choose - replace VISERVERNAME with your server name.
Connect-VIServer VISERVERNAME

$vmlist = Import-Csv -Path C:\TempDelete\InputFiles\EMAIL_VMs.csv
$vmhost = Get-VMHost VMHOSTNAME

foreach ($vm in $vmlist){
    $vmname = Get-VM -Name $vm.Name
    $deviceName = ($vmhost | Get-ScsiLun -CanonicalName $vm.CanonicalName)[0].ConsoleDeviceName
    New-HardDisk -VM $vmname -DiskType RawPhysical -DeviceName $deviceName | New-ScsiController -Type ParaVirtual
    }

Disconnect-VIServer * -Force -Confirm:$false