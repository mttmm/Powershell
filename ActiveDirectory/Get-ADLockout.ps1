Import-Module ActiveDirectory
$UserName = Read-Host "Please enter username"
#Get main DC
$PDC = (Get-ADDomainController -Filter * | Where-Object {$_.OperationMasterRoles -contains "PDCEmulator"})
#Get user info
$UserInfo = Get-ADUser -Identity $UserName
#Search PDC for lockout events with ID 4740
$LockedOutEvents = Get-WinEvent -ComputerName "$PDC.HostName" -FilterHashtable @{LogName = 'Security'; Id = 4740} -ErrorAction Stop | Sort-Object -Property TimeCreated -Descending
#Parse and filter out lockout events
Foreach($Event in $LockedOutEvents)
  {
    If($Event | Where {$_.Properties[2].value -match $UserInfo.SID.Value})
    {

      $Event | Select-Object -Property @(
        @{Label = 'User'; Expression = {$_.Properties[0].Value}}
        @{Label = 'DomainController'; Expression = {$_.MachineName}}
        @{Label = 'EventId'; Expression = {$_.Id}}
        @{Label = 'LockoutTimeStamp'; Expression = {$_.TimeCreated}}
        @{Label = 'Message'; Expression = {$_.Message -split "`r" | Select -First 1}}
        @{Label = 'LockoutSource'; Expression = {$_.Properties[1].Value}}
      )

    }}