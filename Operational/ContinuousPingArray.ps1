

$pcs = "RAD7-GNL-01","RAD7-GHP-01","RAD7-GEN-01"
while ($true){
foreach ($pc in $pcs){
    if ( Test-Connection -ComputerName $pc -Count 1 -ErrorAction SilentlyContinue)
        {Write-host "$pc is up"}
        else {
        Get-date ; Write-Warning "$pc is down"
        }

}
}

