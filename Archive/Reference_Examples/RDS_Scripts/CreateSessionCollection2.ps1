

$CollectionName = "Education Demo"
$SessionHost = @("nuve-rdsh-edu01.nuvestack.com", "nuve-rdsh-edu02.nuvestack.com")
$CollectionDescription = “Education Demo”
$ConnectionBroker = "nuvebroker.nuvestack.com"


import-module remotedesktop

New-RDSessionCollection -CollectionName $CollectionName -SessionHost $SessionHost -CollectionDescription $CollectionDescription -ConnectionBroker $ConnectionBroker