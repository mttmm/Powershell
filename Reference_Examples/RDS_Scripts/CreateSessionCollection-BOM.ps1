# Creates a new collection in an existing RDS deployment

$CollectionName = "Bommarito RemoteApp"
$SessionHost = @("BOMRDSHAPP01.nuvestack.com")
$CollectionDescription = “Bommarito RemoteApp”
$ConnectionBroker = "BOMRDCB01.nuvestack.com"


import-module remotedesktop

New-RDSessionCollection -CollectionName $CollectionName -SessionHost $SessionHost -CollectionDescription $CollectionDescription -ConnectionBroker $ConnectionBroker