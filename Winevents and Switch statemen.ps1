#region prep
Get-WinEvent -LogName system -MaxEvents 5
Get-WinEvent -ComputerName crc-ahartsel.columbusrad.local -Credential (Get-Credential) -LogName  application -MaxEvents 25

#endregion

#region FilterHashtable

#region Get events by level
Get-WinEvent -FilterHashtable @{
    Logname = 'system'
    Level   = 1, 2 #1 Critical, 2 Error, 3 Warning, 4 Information
}
#endregion
#region Get account lockouts
Get-WinEvent -FilterHashtable @{
    Logname = 'security'
    ID      = 4740
}
#endregion
#region Get events by provider
Get-WinEvent -FilterHashtable @{
    Logname      = 'System'
    ProviderName = 'Microsoft-Windows-GroupPolicy'
}
#endregion
#region Computers to search
$computername = 'crcmgmt01', 'crcnms01'
ForEach ($computer in $computername) {
    Get-WinEvent -ComputerName $computer -FilterHashtable @{
        Logname = 'system'
        Level   = 1, 2 #1 Critical, 2 Error, 3 Warning, 4 Information
    }
}
#endregion
#region Get lockouts from domain controllers
$computername = Get-ADDomainController -Filter * | Select-Object -ExpandProperty Name
Foreach ($computer in $computername) {
    Get-WinEvent -ComputerName $computer -FilterHashtable @{
        Logname = 'Security'
        ID      = 4740
    }
}
#endregion
#region Output data to CSV
$output = @()
$computername = 'crcmgmt01', 'crcnms01' #Get-ADComputer -Filter * | Select-object -ExpandProperty Name
Foreach ($computer in $computername) {
    $events = Get-WinEvent -FilterHashtable @{
        Logname      = 'System'
        ProviderName = 'Microsoft-Windows-GroupPolicy'
        Level        = 1, 2
    }
    ForEach ($event in $events) {
        $output += $event | Add-Member -NotePropertyName 'ComputerName' -NotePropertyValue $Computer -PassThru
    }
}
$output | Export-Csv C:\Temp\Events.csv -NoTypeInformation
#endregion
#endregion


Get-CimInstance -ComputerName crcdc04 -ClassName Win32_ComputerSystem

#region Understanding the powershell switch statement
$season = 'Summer'
switch ($season) {
    'Summer' {
        Write-Host "The Season is [$_]."
        break
    }
    'Fall' {
        Write-Host "The Season is [$_]."
        break
    }
    'Winter' {
        Write-Host "The Season is [$_]."
        break
    }
    'Spring' {
        Write-Host "The Season is [$_]."
        break
    }
    default {
        Write-Host "Unknown Season - Fuckoff"
    }
}
#endregion
#region process array elements
$seasons = 'Summer', 'Fall'
switch ($seasons) {
    'Summer' {
        Write-Host "The Season is [$_]."

    }
    'Fall' {
        Write-Host "The Season is [$_]."

    }
    'Winter' {
        Write-Host "The Season is [$_]."

    }
    'Spring' {
        Write-Host "The Season is [$_]."

    }
    default {
        Write-Host "Unknown Season - Fuckoff"
    }
}
#endregion
#region Use wildcard
$shortseason = 'Sumbjk'
switch -Wildcard($shortseason) {
    'Sum*' {
        Write-Host "The Season is [$_]."

    }
    'Fa*' {
        Write-Host "The Season is [$_]."

    }
    'Win*' {
        Write-Host "The Season is [$_]."

    }
    'Spr*' {
        Write-Host "The Season is [$_]."

    }
    default {
        Write-Host "Unknown Season - Fuckoff"
    }
}
#endregion
#region Scriptblocks
$age = 20
switch ($age) {
    {$_ -lt $_} {
        'You are young!'
    }
    {$_ -ge $_} {
        'You are Old!'
    }
    default {
        'unknown age'
    }
}
#endregion