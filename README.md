# peep-admin
This is being developed for use on a Exchange 2010 server to notify SysSecAdmins when a mailbox is accessed with admin privileges. This was started as a simple PowerShell project on 1/11/19 by ~incredincomp

I am currently bumped up agaisnt a debugging wall and if you have any experience running this in your enviroment, please let me know how it went. 

# usage
This is an auditing/forensics tool in the basic sense. This is being developed out of the need to be able to be notified when a mailbox is accessed with administrator privileges and where and who was responsible, and for what. 

There shouldn’t be any specific needs from the user aside from basic server configuration, along with initial program configuration.

This program is being developed for a single specific server instance and may need additional adjustments before working with your current implementation of your server.

# flow notes
The general idea I have at this time-

Generate a GUI window with visual studio WPF to select configuration options for specific cmdlets to search for and maybe what mailboxs to search 

will probably be set up to run on a specific time frame to allow for constant updates/a scheduled event with windows event manager

A Powershell script to retrieve the audit log history of a exchange server and save it to an array item for future callback in a notification when certain paramaters are met.

initiate notification to required auditor for further inspection 


included in notification:

cmdlet origination IP

cmdlet Origin USER name or ID 

MAILBOX viewed

TIME and DATE of incident 
