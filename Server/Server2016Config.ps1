# Server 2016 Services
Get-ScheduledTask -TaskName *XblGame* | Disable-ScheduledTask
$Services = 'CDPUserSvc', 'MapsBroker', 'PcaSvc', 'ShellHWDetection', 'OneSyncSvc', 'WpnService'

foreach ($Service in $Services) {
    Stop-Service -Name $Service -PassThru -Verbose | Set-Service -StartupType Disabled -Verbose
}
