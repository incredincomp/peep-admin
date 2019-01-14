These Commands need to be run in the Exchange Management Shell
Info pertaining to access to the Management Shell is located at
https://docs.microsoft.com/en-us/powershell/exchange/exchange-server/open-the-exchange-management-shell?view=exchange-ps


#these will enable mailbox auditing for all user mailboxes within your organization

$UserMailboxes = Get-mailbox -Filter {(RecipientTypeDetails -eq 'UserMailbox')}

$UserMailboxes | ForEach {Set-Mailbox $_.Identity -AuditEnabled $true}
