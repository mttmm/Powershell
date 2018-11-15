

$CollectionName = "KTI"
$SessionHost = @("kti01rdshcol01.nuvestack.com")
$CollectionDescription = “KTI”
$ConnectionBroker = "kti01rdcb01.nuvestack.com"


import-module remotedesktop

New-RDSessionCollection -CollectionName $CollectionName -SessionHost $SessionHost -CollectionDescription $CollectionDescription -ConnectionBroker $ConnectionBroker