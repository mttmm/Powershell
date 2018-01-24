import-module remotedesktop

$apps = @("INFOPATH", "INFOPATH (1)", "MSPUB", "MSACCESS")

foreach ($app in $apps) {
Set-RDRemoteApp -CollectionName "Ballet West Apps" -Alias $app -UserGroups "BW-OfficeProfessional" -ConnectionBroker NUVE-RDCB01.NUVESTACK.COM
}