function Test-FirewallAllServer {
$servers=(Get-ADComputer -Filter * -Properties Operatingsystem | Where-Object {$_.operatingsystem -like "*server*"}).Name
$check=Invoke-Command -ComputerName $servers {Get-NetFirewallProfile -Profile Domain | Select-Object -ExpandProperty Enabled} -ErrorAction SilentlyContinue
$line="__________________________________________________________"
$line2="=========================================================="
$en=$check | ? value -EQ "true"
$di=$check | ? value -EQ "false"
If ($en -ne $null) {
Write-Host ""; Write-Host "The following Windows Server have their firewall enabled:" -ForegroundColor Green; $line; Write-Output ""$en.PSComputerName"";Write-Host ""
}
If ($di -ne $null) {
Write-Host ""; Write-Host "The following Windows Server have their firewall disabled:" -ForegroundColor Red ; $line; Write-Output ""$di.PSComputerName""; Write-Host ""
}
If ($di -eq $null) {
Write-Host $line2; Write-Host "All Windows Servers have it's firewall enabled" -ForegroundColor Green; Write-Host ""
}
If ($en -eq $null) {
Write-Host $line2; Write-Host "All Windows Servers have it's firewall disabled" -ForegroundColor Red; Write-Host ""
}
}