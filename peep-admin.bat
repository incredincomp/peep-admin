@ECHO OFF

SET peep-adminDirectory=%~dp0
SET peep-adminScriptPath=%peep-adminDirectory%peep-admin.ps1

PowerShell.exe -WindowStyle Hidden -NoProfile -Command "& {Start-Process PowerShell.exe -ArgumentList '-WindowStyle Hidden -NoProfile -ExecutionPolicy Bypass -File ""%peep-adminScriptPath%""' -Verb RunAs}"

#.\peep-admin.ps1 | .\notify.ps1
