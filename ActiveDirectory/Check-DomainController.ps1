
<#
 # Tests if domain controllers are down
#>

$dcs=(Get-ADDomainController -Filter *).Name
foreach ($items in $dcs) {
If (!(Test-Connection $items -Count 3 -Quiet))
{$itemssite=(Get-ADDomainController $items).site
$IP= (Get-ADDomainController $items).IPv4Address
$date=Get-Date -Format F
Send-MailMessage -From Alert@domain.com -To p.gruenauer@domain.com -SmtpServer EX01 -Subject "Site: $Site | $item is down" -Body "$IP could not be reached at $date.`n`nIf you receive this message again in 15 minutes, $item is probably down."
}
}