# Creates a new collection in an existing RDS deployment

$CollectionName = "KUVEQ"
$SessionHost = @("TONRDSHPET01.nuvestack.com")
$CollectionDescription = “KUVEQ”
$ConnectionBroker = "TONRDCB01.nuvestack.com"


import-module remotedesktop

New-RDSessionCollection -CollectionName $CollectionName -SessionHost $SessionHost -CollectionDescription $CollectionDescription -ConnectionBroker $ConnectionBroker