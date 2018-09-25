$OrgUnit = 'OU=servers,OU=computers,OU=corp,DC=example,DC=com'
$Servers = Get-ADComputer -Filter {(OperatingSystem -like '*Server*') -and (Enabled -eq $True)} -SearchBase $OrgUnit -Properties ManagedBy
$wmiSplat = @{
    ComputerName = $env:COMPUTERNAME
    Class = 'Win32_LogicalDisk'
    Filter = 'DriveType = 3 AND VolumeName != "RESERVED_PAGING_FILE"'
    Property = 'DeviceID', 'FreeSpace', 'Size', 'VolumeName'
    ErrorAction = 'Stop'
}
$Disks = Get-WmiObject @wmiSplat

Foreach ($Disk in $Disks){
try{
    $PctUsed = ($Disk.Size - $Disk.FreeSpace) / $Disk.Size
    [PSCustomObject] [Ordered] @{
        ComputerName =     $env:COMPUTERNAME
        ManagedBy =        $ManagedBy
        DriveLetter =      $Disk.DeviceID
        VolumeName =       $Disk.VolumeName
        SizeRemaining =    $Disk.FreeSpace
        SizeRemainingGB =  [Math]::Round($Disk.FreeSpace / 1GB, 2)
        Size =             $Disk.Size
        SizeGB =           [Math]::Round($disk.Size /1GB, 2)
        Usage =            $PctUsed.ToString("P")
      }
}catch{

        [PSCustomObject] [Ordered] @{
        ComputerName =    $env:COMPUTERNAME
        ManagedBy =       $ManagedBy
        DriveLetter =     $null
        VolumeName =      $null
        SizeRemaining =   $null
        SizeRemainingGB = $null
        Size =            $null
        SizeGB =          $null
        Usage =           $_.ExceptionMessage
        }
      }
}
  
        
    

