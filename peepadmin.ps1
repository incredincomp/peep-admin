#An administrator who has been assigned the Full Access permission to a user's mailbox is considered a delegated user.
#

$UserMailboxes = Get-mailbox -Filter {(RecipientTypeDetails -eq 'UserMailbox')}

$UserMailboxes | ForEach {Set-Mailbox $_.Identity -AuditEnabled $true}

