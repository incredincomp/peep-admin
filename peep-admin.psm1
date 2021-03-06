<#function peep-admin {#>
Param (
	[Parameter(
		Position=0,
		Mandatory=$true,
		ValueFromPipeline=$true,
		ValueFromPipelineByPropertyName=$true)
	]
	$SearchResults,
	$DisplayNotify
	$ResultSet
)


$SearchContent = Search-AdminAuditLog -Cmdlets set-mailbox, -IsSuccess $true -UserIds *
$SearchResults = $SearchContent

#need to finish this command to match scope
<#Search-AdminAuditLog
      [[-Cmdlets <MultiValuedProperty>]
      [-DomainController <Fqdn>]
      [-EndDate <ExDateTime>]
      [-IsSuccess <$true | $false>]
      [-ObjectIds <MultiValuedProperty>]
      [-Parameters <MultiValuedProperty>]
      [-ResultSize <Int32>]
      [-StartDate <ExDateTime>]
      [-StartIndex <Int32>]
      [-UserIds <MultiValuedProperty>]
      [-ExternalAccess <$true | $false>]
      [<CommonParameters>]
####      
Search-MailboxAuditLog
      [-Mailboxes <MultiValuedProperty>]
      [-DomainController <Fqdn>]
      [-EndDate <ExDateTime>]
      [-ExternalAccess <$true | $false>]
      [-HasAttachments <$true | $false>]
      [-LogonTypes <MultiValuedProperty>]
      [-Operations <MultiValuedProperty>]
      [-ResultSize <Int32>]
      [-StartDate <ExDateTime>]
      [<CommonParameters>]
#>

function global.DisplayNotify {
	Param(
	[parameter(Mandatory=$true,
    ValueFromPipeline=$true)]
	[String[]]
	$ResultSet
	)
#this adds pop up functionality with Add-Type to add the PresentationFramework from Microsoft system files
    Add-Type -AssemblyName PresentationCore,PresentationFramework

      $ButtonType = [System.Windows.MessageBoxButton]::OKCancel #Generates a button that says ok for acknowledgement
      $MessageboxTitle = "Mailbox Accessed" #Sets Messagebox Title
      $MessageboxBody = "$ResultSet[3] `n$ResultSet[0] `n$ResultSet[4] `n$ResultSet[1] `n$ResultSet[2]" #sets Messagebox text as $ResultSet via array objects
      $MessageIcon = [System.Windows.MessageBoxImage]::Warning #sets the icon for the pop up box to an exclamation warning
      $Notify = [System.Windows.MessageBox]::Show($MessageboxBody,$MessageboxTitle,$ButtonType,$MessageIcon) 
  #Saves the message box result to a variable for condition checking
      [console]::beep(1000,1) #triggers a tone to tag along with notification box
      switch( $Notify ){ #conditional statement if the user would like further information       
            OK     { $ShowMore }
	        Cancel { break     }
      } 
}


Begin {
	
	
	# Make sure the array is null
	[array]$ResultSet = $null
	
	# Set the counter to 1
	$i = 1
	
	<# Obsolete
	If resolveCaller is called it can take much longer to run so notify the user of that
	if ($ResolveCaller){Write-Warning "ResolveCaller specified; Script will take significantly longer to run as it attemps to resolve the primary SMTP address of each calling user.  Progress updates will be provided every 25 entries."}#>
}

Process {
	
	# Deal with each object in the input
	$SearchResults | foreach {
		
		# Reset the result object
		$Result = New-Object PSObject
		
		# Get the alias of the User that ran the command
		$user = ($_.caller.split("/"))[-1]
			
		# attempt to resolve the recipient
		[string]$Recipient = (get-recipient $user -erroraction silentlycontinue)primarysmtpaddress
			
			# if we get a result then put that in the output otherwise do nothing
			If (!([string]::IsNullOrEmpty($Recipient))){$user = $Recipient}
			
		
		
		# Build the command that was run
		$cmdltsran = $_.cmdletparameters
		[string]$FullCommand = $_.cmdletname
		
		# Get all of the switches and add them in "human" form to the output
		foreach ($parameter in $cmdltsran){
							
			# Format our values depending on what they are so that they are as close
			# a match as possible for what would have been entered
			switch -regex ($parameter.value)
			{
			
				# If we have a multi value array put in then we need to break it out and add quotes as needed
				'[;]'	{ 
			
					# Reset the formatted value string
					$FormattedValue = $null
					
					# Split it into an array
					$valuearray = $switch.current.split(";")
					
					# For each entry in the array add quotes if needed and add it to the formatted value string
					$valuearray | foreach {
						if ($_ -match "[ \t]"){$FormattedValue = $FormattedValue + "`"" + $_ + "`";"}
						else {$FormattedValue = $FormattedValue + $_ + ";"}
					}
					
					# Clean up the trailing ;
					$FormattedValue = $FormattedValue.trimend(";")
					
					# Add our switch + cleaned up value to the command string
					$FullCommand = $FullCommand + " -" + $parameter.name + " " + $FormattedValue
				}
				
				# If we have a value with spaces add quotes
				'[ \t]'				{$FullCommand = $FullCommand + " -" + $parameter.name + " `"" + $switch.current + "`""}
				
				# If we have a true or false format them with :$ in front ( -allow:$true )
				'^True$|^False$'	{$FullCommand = $FullCommand + " -" + $parameter.name + ":`$" + $switch.current}
				
				# Otherwise just put the switch and the value
				default				{$FullCommand = $FullCommand + " -" + $parameter.name + " " + $switch.current}
			
			}
		}
		
		# Format our modified object
		if ([string]::IsNullOrEmpty($_.objectModified)){$ObjModified = ""}
		else { 
			$ObjModified = ($_.objectmodified.split("/"))[-1]
			$ObjModified = ($ObjModified.split("\"))[-1]
		}
		
		# Get just the name of the cmdlet that was run
		[string]$cmdlet = $_.CmdletName
		
		# Build the result object to return our values
		$Result | Add-Member -MemberType NoteProperty -Value $user -Name Caller
		$Result | Add-Member -MemberType NoteProperty -Value $cmdlet -Name Cmdlet
		$Result | Add-Member -MemberType NoteProperty -Value $FullCommand -Name FullCommand
		$Result | Add-Member -MemberType NoteProperty -Value $_.rundate -Name RunDate
		$Result | Add-Member -MemberType NoteProperty -Value $ObjModified -Name ObjectModified
		
		# Add the object to the array to be returned
		global.$ResultSet = $ResultSet + $Result
		
	}
}

# Final steps
End {
		# Return the array set
		Return global.$ResultSet
		global.$ResultSet = $ResultSet
			switch ( $ResultSet )
			$ResultSet.Count -eq 0 ( break )	
			$ResultSet.Count -gt 0 ( $DisplayNotify <#& send logs into a file for incase you miss notify?#> )

}



<#
 
.SYNOPSIS
Parses the output of Search-AdminAuditlog to produce more readable results.
.DESCRIPTION
Takes the output of the Search-AdminAuditlog as an input and reconstructs the
results into a more easily read structure.
Results can be stored in a variable and sent to the script with -SearchResults
or taken directly off of a pipeline and converted.
Output should generally contain commands that can be copied and pasted into
an Exchange/Exchange Online Shell and run directly with little to no
Modification.
 
.PARAMETER SeachResults
Output of the Search-AdminAuditLog. Either stored in a variable or pipelined
into the script.

.OUTPUTS
Creates an output that contains the following information:
Caller         : Person who ran the command
Cmdlet         : Cmdlet that was run
FullCommand    : Reconstructed full command that was run
RunDate        : Date and Time command was run
ObjectModified : Object that was modified by the command
.EXAMPLE
$Search = Search-AdminAuditLog
$search | C:\Scripts\Get-SimpleAuditLogReport.ps1 -agree
Converts the results of Search-AdminAuditLog and sends the output to the screen
.EXAMPLE
Search-AdminAuditLog | C:\Scripts\Get-SimpleAuditlogReport.ps1 -agree | Export-CSV -path C:\temp\auditlog.csv
Converts the restuls of Search-AdminAuditLog and sends the output to a CSV file
.EXAMPLE
$MySearch = Search-AdminAuditLog -cmdlet set-mailbox
C:\Script\C:\Scripts\Get-SimpleAuditLogReport.ps1 -agree -SearchResults $MySearch
Finds all instances of set-mailbox
Converts them by passing in the results to the switch SearchResults
Outputs to the screen
#>







