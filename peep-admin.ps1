#An administrator who has been assigned the Full Access permission to a user's mailbox is considered a delegated user.
#https://docs.microsoft.com/en-us/powershell/module/exchange/policy-and-compliance-audit/Search-AdminAuditLog?view=exchange-ps

[CmdletBinding()]
param (
	
	[Parameter( Mandatory=$false)]
	[string]$Mailbox,

	[Parameter( Mandatory=$false)]
	[switch]$SendEmail,

	[Parameter( Mandatory=$false)]
	[string]$MailFrom,

	[Parameter( Mandatory=$false)]
	[string]$MailTo,

	[Parameter( Mandatory=$false)]
	[string]$MailServer,

    [Parameter( Mandatory=$false)]
    [int]$Hours = 24

	)

#...................................
# Variables
#...................................

$now = Get-Date											#Used for timestamps
$date = $now.ToShortDateString()						#Short date format for email message subject

$report = @()
$reportemailsubject = "Mailbox Audit Logs for $mailbox in last $hours hours."

$myDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$rawfile = "$myDir\AuditLogEntries.csv"
$htmlfile = "$myDir\AuditLogEntries.html"

#Add Exchange 2010/2013 snapin if not already loaded in the PowerShell session
if (!(Get-PSSnapin | where {$_.Name -eq "Microsoft.Exchange.Management.PowerShell.E2010"}))
{
	try
	{
		Add-PSSnapin Microsoft.Exchange.Management.PowerShell.E2010 -ErrorAction STOP
	}
	catch
	{
		#Snapin was not loaded
		Write-Warning $_.Exception.Message
		EXIT
	}
	. $env:ExchangeInstallPath\bin\RemoteExchange.ps1
	Connect-ExchangeServer -auto -AllowClobber
}

$auditlogentries = @()

$identity = (Get-Mailbox $mailbox).Identity

$auditlogentries = Search-MailboxAuditLog -Identity $identity -LogonTypes Delegate -StartDate (Get-Date).AddHours(-$hours) -ShowDetails

if ($($auditlogentries.Count) -gt 0)
{
#    Write-Host "Writing raw data to $rawfile"
    $auditlogentries | Export-CSV $rawfile -NoTypeInformation -Encoding UTF8

    foreach ($entry in $auditlogentries)
    {
        $reportObj = New-Object PSObject
        $reportObj | Add-Member NoteProperty -Name "Mailbox" -Value $entry.MailboxResolvedOwnerName
        $reportObj | Add-Member NoteProperty -Name "Mailbox UPN" -Value $entry.MailboxOwnerUPN
        $reportObj | Add-Member NoteProperty -Name "Timestamp" -Value $entry.LastAccessed
        $reportObj | Add-Member NoteProperty -Name "Accessed By" -Value $entry.LogonUserDisplayName
        $reportObj | Add-Member NoteProperty -Name "Operation" -Value $entry.Operation
        $reportObj | Add-Member NoteProperty -Name "Result" -Value $entry.OperationResult
        $reportObj | Add-Member NoteProperty -Name "Folder" -Value $entry.FolderPathName
        if ($entry.ItemSubject)
        {
            $reportObj | Add-Member NoteProperty -Name "Subject Lines" -Value $entry.ItemSubject
        }
        else
        {
            $reportObj | Add-Member NoteProperty -Name "Subject Lines" -Value $entry.SourceItemSubjectsList
        }

        $report += $reportObj
    }
	
	
	
	$htmlbody = $report | ConvertTo-Html -Fragment

	$htmlhead="<html>
				<style>
				BODY{font-family: Arial; font-size: 8pt;}
				H1{font-size: 22px; font-family: 'Segoe UI Light','Segoe UI','Lucida Grande',Verdana,Arial,Helvetica,sans-serif;}
				H2{font-size: 18px; font-family: 'Segoe UI Light','Segoe UI','Lucida Grande',Verdana,Arial,Helvetica,sans-serif;}
				H3{font-size: 16px; font-family: 'Segoe UI Light','Segoe UI','Lucida Grande',Verdana,Arial,Helvetica,sans-serif;}
				TABLE{border: 1px solid black; border-collapse: collapse; font-size: 8pt;}
				TH{border: 1px solid #969595; background: #dddddd; padding: 5px; color: #000000;}
				TD{border: 1px solid #969595; padding: 5px; }
				td.pass{background: #B7EB83;}
				td.warn{background: #FFF275;}
				td.fail{background: #FF2626; color: #ffffff;}
				td.info{background: #85D4FF;}
				</style>
				<body>
                <p>Report of mailbox audit log entries for $mailbox in the last $hours hours.</p>"
		
	$htmltail = "</body></html>"	

	$htmlreport = $htmlhead + $htmlbody + $htmltail

#    Write-Host "Writing report data to $htmlfile"
    $htmlreport | Out-File $htmlfile -Encoding UTF8
    
}
else
{
    Write-Host "No audit log entries found."
}

#this saves the results from the Search-AdminAuditLog into an array for reference to display properties in notification window
#$Results = Search-AdminAuditLog - Cmdlets <cmdlet 1, cmdlet 2, ...> -Parameters <parameter 1, parameter 2, ...> -StartDate <start date> -EndDate <end date> -UserIds <user IDs> -ObjectIds <object IDs> -IsSuccess <$True | $False >

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




