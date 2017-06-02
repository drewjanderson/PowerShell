# This was written for an Exchange 2007 system. It may be compatible with newer versions.

# Adds the Exchange 2007 snapin
Add-PSSnapin Microsoft.Exchange.Management.PowerShell.Admin

# Gathers all mailboxes, selects only the Display Name and Forwarding Address, and outputs only
# those that the Forwarding Address is not NULL
Get-Mailbox -ResultSize unlimited | Select-Object DisplayName, ForwardingAddress | Where-Object {$_.ForwardingAddress -ne $Null}