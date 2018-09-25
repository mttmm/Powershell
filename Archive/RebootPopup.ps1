$CurrentDate = Get-Date
$LastBootUpTime = Get-WmiObject win32_operatingsystem | select csname, @{LABEL='LastBootUpTime';EXPRESSION={$_.ConverttoDateTime($_.lastbootuptime)}} 
$TimeSpan = New-TimeSpan -Start $LastBootUpTime.lastbootuptime -End $CurrentDate

If ($TimeSpan.Days -lt 7) {

    $Days = $TimeSpan.Days
    $wshell = New-Object -ComObject Wscript.Shell
    $wshell.Popup("Your PC hasn't been rebooted since $Days days. We recommend to reboot the PC at least once a week, to prevent disruption.",0,"Reboot Notification",0x1)
}