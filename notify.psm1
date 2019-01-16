function newSearch {

}



function notify 
{
#this adds pop up functionality with Add-Type to add the PresentationFramework from Microsoft system files
Add-Type -AssemblyName PresentationCore,PresentationFramework

  $ButtonType = [System.Windows.MessageBoxButton]::OKCancel #Generates a button that says ok for acknowledgement
  $MessageboxTitle = "Mailbox Accessed" #Sets Messagebox Title
  $MessageboxBody = "test" #sets Messagebox text, will need to call a variable that will be set by main peep-admin script
  $MessageIcon = [System.Windows.MessageBoxImage]::Warning #sets the icon for the pop up box to an exclamation warning
  $Result = [System.Windows.MessageBox]::Show($MessageboxBody,$MessageboxTitle,$ButtonType,$MessageIcon) 
  #Saves the message box result to a variable for condition checking
  switch( $Result ) 
  { #conditional statement to decide what is to be done with the information and if the user would like further information
	  OK     { $ShowMore }
	  Cancel { break     }
  } 
}
