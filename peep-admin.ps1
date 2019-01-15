#An administrator who has been assigned the Full Access permission to a user's mailbox is considered a delegated user.
#https://docs.microsoft.com/en-us/powershell/module/exchange/policy-and-compliance-audit/Search-AdminAuditLog?view=exchange-ps

$CurrentLoc = Get-Location

#this saves the results from the Search-AdminAuditLog into an array for reference to display properties in notification window
$Results = Search-AdminAuditLog - Cmdlets <cmdlet 1, cmdlet 2, ...> -Parameters <parameter 1, parameter 2, ...> -StartDate <start date> -EndDate <end date> -UserIds <user IDs> -ObjectIds <object IDs> -IsSuccess <$True | $False >

#to call array objects, use:
#$Results[4].CmdletParameters
#$Results[4].ModifiedProperties

#Copy

#Create

#FolderBind

#HardDelete

#MailboxLogin

#MessageBind

#Move

#MoveToDeletedItems

#SendAs

#SendOnBehalf

#SoftDelete

#Update




