@ECHO OFF

SET ThisScriptsDirectory=%~dp0
SET PowerShellScriptPath=%ThisScriptsDirectory%peep-admin.ps1

PowerShell.exe -WindowStyle Hidden -NoProfile -Command "& {Start-Process PowerShell.exe -ArgumentList '-WindowStyle Hidden -NoProfile -ExecutionPolicy Bypass -File ""%PowerShellScriptPath%""' -Verb RunAs}"

#.\peep-admin.ps1 | .\notify.ps1
