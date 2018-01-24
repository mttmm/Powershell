$CurrentDate = Get-Date
$LastBootUpTime = Get-WmiObject win32_operatingsystem | select csname, @{LABEL='LastBootUpTime';EXPRESSION={$_.ConverttoDateTime($_.lastbootuptime)}} 
$TimeSpan = New-TimeSpan -Start $LastBootUpTime.lastbootuptime -End $CurrentDate

If ($TimeSpan.Days -lt 7) {
    Write-Output "ok"
}