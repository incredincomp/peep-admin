# https://docs.microsoft.com/en-us/previous-versions/windows/internet-explorer/ie-developer/windows-scripting/x83z1d9f(v=vs.84)
# 
# https://powershell.org/2013/04/powershell-popup/


#this adds pop up functionality with Add-Type to add the PresentationFramework from Microsoft system files

Add-Type -AssemblyName PresentationCore,PresentationFramework

#Generates a button that says ok for acknowledgement

$ButtonType = [System.Windows.MessageBoxButton]::OKCancel

#Sets Messagebox Title
$MessageboxTitle = “Mailbox Accessed”

#sets Messagebox text, will need to call a variable that will be set by main peep-admin script
$Messageboxbody = "test"

#sets the icon for the pop up box to an exclamation warning
$MessageIcon = [System.Windows.MessageBoxImage]::Warning

#Saves the message box result to a variable for condition checking
$Result = [System.Windows.MessageBox]::Show($MessageBody,$MessageTitle,$ButtonType,$MessageIcon)

#conditional statement to decide what is to be done with the information and if the user would like further information
