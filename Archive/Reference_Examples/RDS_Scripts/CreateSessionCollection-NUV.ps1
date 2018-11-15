# Creates a new collection in an existing RDS deployment

$CollectionName = "Nuvestack"
$SessionHost = @("TONRDSHNUV01.nuvestack.com","TONRDSHNUV03.nuvestack.com","TONRDSHNUV03.nuvestack.com")
$CollectionDescription = “Nuvestack”
$ConnectionBroker = "TONRDCB01.nuvestack.com"


import-module remotedesktop

New-RDSessionCollection -CollectionName $CollectionName -SessionHost $SessionHost -CollectionDescription $CollectionDescription -ConnectionBroker $ConnectionBroker