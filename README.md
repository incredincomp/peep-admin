# peep-admin
This is being developed for use on a Exchange 2010 server to notify SysSecAdmins when a mailbox is accessed with admin privledges. This is mostly a PowerShell project, but may need to implement a bash script/python script for the desired effects.

# usage
This is an auditing/forensics tool in the basic sense. This is being devolped out of the need to be able to be notified when a mailbox is accessed with administrator privledges and where and who was responsible, and for what. 

There shouldnt be any specific needs from the user aside from basic server configuration, along with inital program configuration.
That being said, this program is being devoloped for a single specific server instance and may need additional adjustments before working with your current implementation of your server.

# flow
The general idea I have at this time-will probably be set up to run on a specific time frame to allow for constant updates/a scheduled event
A Powershell script to retrieve the audit log history of a exchange server and save the output in a file in a safe folder.
Search-AdminAuditLog -Cmdlets
-LogonTypes
a Bash script to grep through said said saved file to find pertinent information
Save/or initiate notification to required auditor for further inspection 
included in notification: 
