$ref=(Get-ADGroupMember -Identity "Domain Admins").Name
Start-Sleep -Seconds 86398
$diff=(Get-ADGroupMember -Identity "Domain Admins").Name
$result=(Compare-Object -ReferenceObject $ref -DifferenceObject $diff | Where-Object {$_.SideIndicator -eq "=>"} | Select-Object -ExpandProperty InputObject) -join ", "
If ($result)
{msg * "The following user was added to the Domain Admins Group: $result"}

<#
$Action=New-ScheduledTaskAction -Execute "powershell" -Argument "C:\Alerts\domain_admins.ps1"
$Trigger=New-ScheduledTaskTrigger -Once -At (Get-Date) -RepetitionInterval (New-TimeSpan -Seconds 86400) -RepetitionDuration ([timespan]::MaxValue)
$Set=New-ScheduledTaskSettingsSet
$Principal=New-ScheduledTaskPrincipal -UserId "sid-500\administrator" -LogonType S4U
$Task=New-ScheduledTask -Action $Action -Trigger $Trigger -Settings $Set -Principal $Principal
Register-ScheduledTask -TaskName "Domain Admins Check" -InputObject $Task -Force

#>
