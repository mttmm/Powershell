# Creates a new collection in an existing RDS deployment

$CollectionName = "Ballet West"
$SessionHost = @("TONRDSHBAL01.nuvestack.com","TONRDSHBAL02.nuvestack.com","TONRDSHBAL03.nuvestack.com")
$CollectionDescription = “Ballet West”
$ConnectionBroker = "TONRDCB01.nuvestack.com"


import-module remotedesktop

New-RDSessionCollection -CollectionName $CollectionName -SessionHost $SessionHost -CollectionDescription $CollectionDescription -ConnectionBroker $ConnectionBroker