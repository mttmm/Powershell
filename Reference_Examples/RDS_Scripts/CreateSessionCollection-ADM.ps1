# Creates a new collection in an existing RDS deployment

$CollectionName = "Janik"
$SessionHost = @("TONRDSHJAN01.nuvestack.com")
$CollectionDescription = “Janik”
$ConnectionBroker = "TONRDCB01.nuvestack.com"


import-module remotedesktop

New-RDSessionCollection -CollectionName $CollectionName -SessionHost $SessionHost -CollectionDescription $CollectionDescription -ConnectionBroker $ConnectionBroker