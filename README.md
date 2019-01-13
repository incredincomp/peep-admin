# peep-admin
This is being developed for use on a Exchange 2010 server to notify SysSecAdmins when a mailbox is accessed with admin privileges. This is a PowerShell project
# usage
This is an auditing/forensics tool in the basic sense. This is being developed out of the need to be able to be notified when a mailbox is accessed with administrator privileges and where and who was responsible, and for what. 

There shouldn’t be any specific needs from the user aside from basic server configuration, along with initial program configuration.
This program is being developed for a single specific server instance and may need additional adjustments before working with your current implementation of your server.

# flow
The general idea I have at this time-

will probably be set up to run on a specific time frame to allow for constant updates/a scheduled event

A Powershell script to retrieve the audit log history of a exchange server and save the output in a file in a safe folder.

Search-AdminAuditLog -Cmdlets

-LogonTypes

Save/or initiate notification to required auditor for further inspection 

https://docs.microsoft.com/en-us/previous-versions/windows/internet-explorer/ie-developer/windows-scripting/x83z1d9f(v=vs.84)

included in notification:

cmdlet origination IP

cmdlet Origin USER name or ID 

MAILBOX viewed

TIME and DATE of incident 
