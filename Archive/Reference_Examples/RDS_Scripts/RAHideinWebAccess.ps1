import-module remotedesktop

$apps = @("MSACCESS")

foreach ($app in $apps) {
Set-RDRemoteApp -CollectionName "Ballet West Apps" -Alias $app -ShowInWebAccess $false
}