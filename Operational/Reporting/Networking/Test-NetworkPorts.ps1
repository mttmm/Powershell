
<#
 # Tests multiple ports
#>

function Test-Port
{$computer=Read-Host "Computername | IP Address?"
 $port=Read-Host "Port Numbers? Separate them by comma"
 $port.split(',') | Foreach-Object -Process {If (($a=Test-NetConnection $computer -Port $_ -WarningAction SilentlyContinue).tcpTestSucceeded -eq $true) {Write-Host $a.Computername $a.RemotePort -ForegroundColor Green -Separator " ==> "} else {Write-Host $a.Computername $a.RemotePort -Separator " ==> " -ForegroundColor Red}}
 }