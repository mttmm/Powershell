Function Get-Uptime {
$os = Get-WmiObject win32_operatingsystem -ErrorAction SilentlyContinue
$uptime = (Get-Date) - $os.ConvertToDateTime($os.LastBootUpTime)
Write-Output ("Last boot: " + $os.ConvertToDateTime($os.LastBootUpTime) )
Write-Output ("Uptime   : " + $uptime.Days + " Days " + $uptime.Hours + " Hours " + $uptime.Minutes + " Minutes" )
}

Get-Uptime