# Server 2016 Services
Get-Service -Name MapsBroker | Set-Service -StartupType Disabled
Get-ScheduledTask -TaskName *XblGame* | Disable-ScheduledTask