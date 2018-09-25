<#

 Author : Rich Mawdsley
 Website : www.EverythingSCCM.com
 Twitter : @RichMawdsley1

 This Powershell has been heavily adapted and changed for the purpose of creating groups designed for Windows Updates.
 Original script credit goes to Benoit Lecours below.  Thank you!

 

 Author  : Benoit Lecours 
 Website : www.SystemCenterDudes.com
 Twitter : @scdudes
 

#>

#Load Configuration Manager PowerShell Module
Import-module ($Env:SMS_ADMIN_UI_PATH.Substring(0,$Env:SMS_ADMIN_UI_PATH.Length-5) + '\ConfigurationManager.psd1')

#Get SiteCode
$SiteCode = Get-PSDrive -PSProvider CMSITE
Set-location $SiteCode":"

#Error Handling and output
Clear-Host
$ErrorActionPreference= 'SilentlyContinue'
$Error1 = 0

#Refresh Schedule
$Schedule = New-CMSchedule –RecurInterval Days –RecurCount 7

#List of Collections Query
$Collection1 = @{Name = "Development - Windows Updates - All Windows Servers"; Query = "select SMS_R_SYSTEM.ResourceID,SMS_R_SYSTEM.ResourceType,SMS_R_SYSTEM.Name,SMS_R_SYSTEM.SMSUniqueIdentifier,SMS_R_SYSTEM.ResourceDomainORWorkgroup,SMS_R_SYSTEM.Client from SMS_R_System where SMS_R_System.OperatingSystemNameandVersion like '%Microsoft Windows NT Server 6.1%' or SMS_R_System.OperatingSystemNameandVersion like '%Microsoft Windows NT Server 6.3%' or SMS_R_System.OperatingSystemNameandVersion like '%Microsoft Windows NT Server 10.0%'"}
$Collection2 = @{Name = "Production - Windows Updates - All Windows Servers"; Query = "select SMS_R_SYSTEM.ResourceID,SMS_R_SYSTEM.ResourceType,SMS_R_SYSTEM.Name,SMS_R_SYSTEM.SMSUniqueIdentifier,SMS_R_SYSTEM.ResourceDomainORWorkgroup,SMS_R_SYSTEM.Client from SMS_R_System where SMS_R_System.OperatingSystemNameandVersion like '%Microsoft Windows NT Server 6.1%' or SMS_R_System.OperatingSystemNameandVersion like '%Microsoft Windows NT Server 6.3%' or SMS_R_System.OperatingSystemNameandVersion like '%Microsoft Windows NT Server 10.0%'"}
$Collection3 = @{Name = "Development - Windows Updates - Server 2008 R2"; Query = "select SMS_R_SYSTEM.ResourceID,SMS_R_SYSTEM.ResourceType,SMS_R_SYSTEM.Name,SMS_R_SYSTEM.SMSUniqueIdentifier,SMS_R_SYSTEM.ResourceDomainORWorkgroup,SMS_R_SYSTEM.Client from sms_r_system where OperatingSystemNameAndVersion like 'Microsoft Windows NT%Server 6.1'"}
$Collection4 = @{Name = "Production - Windows Updates - Server 2008 R2"; Query = "select SMS_R_SYSTEM.ResourceID,SMS_R_SYSTEM.ResourceType,SMS_R_SYSTEM.Name,SMS_R_SYSTEM.SMSUniqueIdentifier,SMS_R_SYSTEM.ResourceDomainORWorkgroup,SMS_R_SYSTEM.Client from sms_r_system where OperatingSystemNameAndVersion like 'Microsoft Windows NT%Server 6.1'"}
$Collection5 = @{Name = "Development - Windows Updates - Server 2012 R2"; Query = "select SMS_R_SYSTEM.ResourceID,SMS_R_SYSTEM.ResourceType,SMS_R_SYSTEM.Name,SMS_R_SYSTEM.SMSUniqueIdentifier,SMS_R_SYSTEM.ResourceDomainORWorkgroup,SMS_R_SYSTEM.Client from sms_r_system where OperatingSystemNameAndVersion like 'Microsoft Windows NT%Server 6.3'"}
$Collection6 = @{Name = "Production - Windows Updates - Server 2012 R2"; Query = "select SMS_R_SYSTEM.ResourceID,SMS_R_SYSTEM.ResourceType,SMS_R_SYSTEM.Name,SMS_R_SYSTEM.SMSUniqueIdentifier,SMS_R_SYSTEM.ResourceDomainORWorkgroup,SMS_R_SYSTEM.Client from sms_r_system where OperatingSystemNameAndVersion like 'Microsoft Windows NT%Server 6.3'"}
$Collection7 = @{Name = "Development - Windows Updates - Server 2016"; Query = "select SMS_R_SYSTEM.ResourceID,SMS_R_SYSTEM.ResourceType,SMS_R_SYSTEM.Name,SMS_R_SYSTEM.SMSUniqueIdentifier,SMS_R_SYSTEM.ResourceDomainORWorkgroup,SMS_R_SYSTEM.Client from sms_r_system where OperatingSystemNameAndVersion like 'Microsoft Windows NT%Server 10'"}
$Collection8 = @{Name = "Production - Windows Updates - Server 2016"; Query = "select SMS_R_SYSTEM.ResourceID,SMS_R_SYSTEM.ResourceType,SMS_R_SYSTEM.Name,SMS_R_SYSTEM.SMSUniqueIdentifier,SMS_R_SYSTEM.ResourceDomainORWorkgroup,SMS_R_SYSTEM.Client from sms_r_system where OperatingSystemNameAndVersion like 'Microsoft Windows NT%Server 10'"}
$Collection9 = @{Name = "Development - Windows Updates - All Windows Clients"; Query = "select SMS_R_SYSTEM.ResourceID,SMS_R_SYSTEM.ResourceType,SMS_R_SYSTEM.Name,SMS_R_SYSTEM.SMSUniqueIdentifier,SMS_R_SYSTEM.ResourceDomainORWorkgroup,SMS_R_SYSTEM.Client from SMS_R_System where SMS_R_System.OperatingSystemNameandVersion like '%Microsoft Windows NT Workstation 6.1%' or SMS_R_System.OperatingSystemNameandVersion like '%Microsoft Windows NT Workstation 6.3%' or SMS_R_System.OperatingSystemNameandVersion like '%Microsoft Windows NT Workstation 10.0%'"}
$Collection10 = @{Name = "Production - Windows Updates - All Windows Clients"; Query = "select SMS_R_SYSTEM.ResourceID,SMS_R_SYSTEM.ResourceType,SMS_R_SYSTEM.Name,SMS_R_SYSTEM.SMSUniqueIdentifier,SMS_R_SYSTEM.ResourceDomainORWorkgroup,SMS_R_SYSTEM.Client from SMS_R_System where SMS_R_System.OperatingSystemNameandVersion like '%Microsoft Windows NT Workstation 6.1%' or SMS_R_System.OperatingSystemNameandVersion like '%Microsoft Windows NT Workstation 6.3%' or SMS_R_System.OperatingSystemNameandVersion like '%Microsoft Windows NT Workstation 10.0%'"}
$Collection11 = @{Name = "Development - Windows Updates - Windows 10"; Query = "select SMS_R_SYSTEM.ResourceID,SMS_R_SYSTEM.ResourceType,SMS_R_SYSTEM.Name,SMS_R_SYSTEM.SMSUniqueIdentifier,SMS_R_SYSTEM.ResourceDomainORWorkgroup,SMS_R_SYSTEM.Client from SMS_R_System where SMS_R_System.OperatingSystemNameandVersion like '%Microsoft Windows NT Workstation 10.0%'"}
$Collection12 = @{Name = "Production - Windows Updates - Windows 10"; Query = "select SMS_R_SYSTEM.ResourceID,SMS_R_SYSTEM.ResourceType,SMS_R_SYSTEM.Name,SMS_R_SYSTEM.SMSUniqueIdentifier,SMS_R_SYSTEM.ResourceDomainORWorkgroup,SMS_R_SYSTEM.Client from SMS_R_System where SMS_R_System.OperatingSystemNameandVersion like '%Microsoft Windows NT Workstation 10.0%'"}
$Collection13 = @{Name = "Development - Windows Updates - Windows 8.1"; Query = "select SMS_R_SYSTEM.ResourceID,SMS_R_SYSTEM.ResourceType,SMS_R_SYSTEM.Name,SMS_R_SYSTEM.SMSUniqueIdentifier,SMS_R_SYSTEM.ResourceDomainORWorkgroup,SMS_R_SYSTEM.Client from SMS_R_System where SMS_R_System.OperatingSystemNameandVersion like '%Microsoft Windows NT Workstation 6.3%'"}
$Collection14 = @{Name = "Production - Windows Updates - Windows 8.1"; Query = "select SMS_R_SYSTEM.ResourceID,SMS_R_SYSTEM.ResourceType,SMS_R_SYSTEM.Name,SMS_R_SYSTEM.SMSUniqueIdentifier,SMS_R_SYSTEM.ResourceDomainORWorkgroup,SMS_R_SYSTEM.Client from SMS_R_System where SMS_R_System.OperatingSystemNameandVersion like '%Microsoft Windows NT Workstation 6.3%'"}
$Collection15 = @{Name = "Development - Windows Updates - Windows 7"; Query = "select SMS_R_SYSTEM.ResourceID,SMS_R_SYSTEM.ResourceType,SMS_R_SYSTEM.Name,SMS_R_SYSTEM.SMSUniqueIdentifier,SMS_R_SYSTEM.ResourceDomainORWorkgroup,SMS_R_SYSTEM.Client from SMS_R_System where SMS_R_System.OperatingSystemNameandVersion like '%Microsoft Windows NT Workstation 6.1%'"}
$Collection16 = @{Name = "Production - Windows Updates - Windows 7"; Query = "select SMS_R_SYSTEM.ResourceID,SMS_R_SYSTEM.ResourceType,SMS_R_SYSTEM.Name,SMS_R_SYSTEM.SMSUniqueIdentifier,SMS_R_SYSTEM.ResourceDomainORWorkgroup,SMS_R_SYSTEM.Client from SMS_R_System where SMS_R_System.OperatingSystemNameandVersion like '%Microsoft Windows NT Workstation 6.1%'"}

#Create Folders and Structure
New-Item -Name 'Windows Update' -Path ".\DeviceCollection\"
New-Item -Name 'Servers' -Path ".\DeviceCollection\Windows Update\"
New-Item -Name 'Server 2008 R2' -Path ".\DeviceCollection\Windows Update\Servers\"
New-Item -Name 'Server 2012 R2' -Path ".\DeviceCollection\Windows Update\Servers\"
New-Item -Name 'Server 2016' -Path ".\DeviceCollection\Windows Update\Servers\"
New-Item -Name 'Workstations' -Path ".\DeviceCollection\Windows Update\"
New-Item -Name 'Windows 10' -Path ".\DeviceCollection\Windows Update\Workstations\"
New-Item -Name 'Windows 8.1' -Path ".\DeviceCollection\Windows Update\Workstations\"
New-Item -Name 'Windows 7' -Path ".\DeviceCollection\Windows Update\Workstations\"

#Set vars for folders
$WindowsUpdateFolder = @{Name = "Windows Update"; ObjectType = 5000; ParentContainerNodeId =0}
$ServersFolder = @{Name = "Windows Update\Servers"; ObjectType = 5000; ParentContainerNodeId =0}
$2008Folder = @{Name = "Windows Update\Servers\Server 2008 R2"; ObjectType = 5000; ParentContainerNodeId =0}
$2012Folder = @{Name = "Windows Update\Servers\Server 2012 R2"; ObjectType = 5000; ParentContainerNodeId =0}
$2016Folder = @{Name = "Windows Update\Servers\Server 2016"; ObjectType = 5000; ParentContainerNodeId =0}
$WorkstationsFolder = @{Name = "Windows Update\Workstations"; ObjectType = 5000; ParentContainerNodeId =0}
$Win10Folder = @{Name = "Windows Update\Workstations\Windows 10"; ObjectType = 5000; ParentContainerNodeId =0}
$Win81Folder = @{Name = "Windows Update\Workstations\Windows 8.1"; ObjectType = 5000; ParentContainerNodeId =0}
$Win7Folder = @{Name = "Windows Update\Workstations\Windows 7"; ObjectType = 5000; ParentContainerNodeId =0}


#Create Default limiting collections
$LimitingCollection = "All Systems"
$LimitingCollctionServersProd = "Production - Windows Updates - All Windows Servers"
$LimitingCollctionServersDev = "Development - Windows Updates - All Windows Servers"
$LimitingCollctionWorkStationProd = "Production - Windows Updates - All Windows Clients"
$LimitingCollctionWorkstationDev = "Development - Windows Updates - All Windows Clients"


#Create Collection
#try{
New-CMDeviceCollection -Name $Collection1.Name -Comment "All Development Windows Servers 2008R2 - 2012 R2 - 2016" -LimitingCollectionName $LimitingCollection -RefreshSchedule $Schedule -RefreshType 2 | Out-Null
Add-CMDeviceCollectionQueryMembershipRule -CollectionName $Collection1.Name -QueryExpression $Collection1.Query -RuleName $Collection1.Name
Write-host *** Collection $Collection1.Name created ***

New-CMDeviceCollection -Name $Collection2.Name -Comment "All Production Windows Servers 2008R2 - 2012 R2 - 2016" -LimitingCollectionName $Collection1.Name -RefreshSchedule $Schedule -RefreshType 2 | Out-Null
Add-CMDeviceCollectionQueryMembershipRule -CollectionName $Collection2.Name -QueryExpression $Collection2.Query -RuleName $Collection2.Name
Write-host *** Collection $Collection2.Name created ***

New-CMDeviceCollection -Name $Collection3.Name -Comment "All Dev Server 2008R2" -LimitingCollectionName $LimitingCollctionServersDev -RefreshSchedule $Schedule -RefreshType 2 | Out-Null
Add-CMDeviceCollectionQueryMembershipRule -CollectionName $Collection3.Name -QueryExpression $Collection3.Query -RuleName $Collection3.Name
Write-host *** Collection $Collection3.Name created ***

New-CMDeviceCollection -Name $Collection4.Name -Comment "All Prod Server 2008R2" -LimitingCollectionName $LimitingCollctionServersProd -RefreshSchedule $Schedule -RefreshType 2 | Out-Null
Add-CMDeviceCollectionQueryMembershipRule -CollectionName $Collection4.Name -QueryExpression $Collection4.Query -RuleName $Collection4.Name
Write-host *** Collection $Collection4.Name created ***

New-CMDeviceCollection -Name $Collection5.Name -Comment "All Dev Server 2012R2" -LimitingCollectionName $LimitingCollctionServersDev -RefreshSchedule $Schedule -RefreshType 2 | Out-Null
Add-CMDeviceCollectionQueryMembershipRule -CollectionName $Collection5.Name -QueryExpression $Collection5.Query -RuleName $Collection5.Name
Write-host *** Collection $Collection5.Name created ***

New-CMDeviceCollection -Name $Collection6.Name -Comment "All Prod Server 2012R2" -LimitingCollectionName $LimitingCollctionServersProd -RefreshSchedule $Schedule -RefreshType 2 | Out-Null
Add-CMDeviceCollectionQueryMembershipRule -CollectionName $Collection6.Name -QueryExpression $Collection6.Query -RuleName $Collection6.Name
Write-host *** Collection $Collection6.Name created ***

New-CMDeviceCollection -Name $Collection7.Name -Comment "All Dev Server 2016" -LimitingCollectionName $LimitingCollctionServersDev -RefreshSchedule $Schedule -RefreshType 2 | Out-Null
Add-CMDeviceCollectionQueryMembershipRule -CollectionName $Collection7.Name -QueryExpression $Collection7.Query -RuleName $Collection7.Name
Write-host *** Collection $Collection7.Name created ***

New-CMDeviceCollection -Name $Collection8.Name -Comment "All Prod Server 2016" -LimitingCollectionName $LimitingCollctionServersProd -RefreshSchedule $Schedule -RefreshType 2 | Out-Null
Add-CMDeviceCollectionQueryMembershipRule -CollectionName $Collection8.Name -QueryExpression $Collection8.Query -RuleName $Collection8.Name
Write-host *** Collection $Collection8.Name created ***

New-CMDeviceCollection -Name $Collection9.Name -Comment "All Development Workstations - Windows 7 - 8.1 - 10" -LimitingCollectionName $LimitingCollection -RefreshSchedule $Schedule -RefreshType 2 | Out-Null
Add-CMDeviceCollectionQueryMembershipRule -CollectionName $Collection9.Name -QueryExpression $Collection9.Query -RuleName $Collection9.Name
Write-host *** Collection $Collection9.Name created ***

New-CMDeviceCollection -Name $Collection10.Name -Comment "All Production Workstations - Windows 7 - 8.1 - 10" -LimitingCollectionName $LimitingCollection -RefreshSchedule $Schedule -RefreshType 2 | Out-Null
Add-CMDeviceCollectionQueryMembershipRule -CollectionName $Collection10.Name -QueryExpression $Collection10.Query -RuleName $Collection10.Name
Write-host *** Collection $Collection10.Name created ***

New-CMDeviceCollection -Name $Collection11.Name -Comment "All Dev Windows 10" -LimitingCollectionName $LimitingCollctionWorkstationDev -RefreshSchedule $Schedule -RefreshType 2 | Out-Null
Add-CMDeviceCollectionQueryMembershipRule -CollectionName $Collection11.Name -QueryExpression $Collection11.Query -RuleName $Collection11.Name
Write-host *** Collection $Collection11.Name created ***

New-CMDeviceCollection -Name $Collection12.Name -Comment "All Prod Windows 10" -LimitingCollectionName $LimitingCollctionWorkStationProd -RefreshSchedule $Schedule -RefreshType 2 | Out-Null
Add-CMDeviceCollectionQueryMembershipRule -CollectionName $Collection12.Name -QueryExpression $Collection12.Query -RuleName $Collection12.Name
Write-host *** Collection $Collection12.Name created ***

New-CMDeviceCollection -Name $Collection13.Name -Comment "All Dev Windows 8.1 " -LimitingCollectionName $LimitingCollctionWorkstationDev -RefreshSchedule $Schedule -RefreshType 2 | Out-Null
Add-CMDeviceCollectionQueryMembershipRule -CollectionName $Collection13.Name -QueryExpression $Collection13.Query -RuleName $Collection13.Name
Write-host *** Collection $Collection13.Name created ***

New-CMDeviceCollection -Name $Collection14.Name -Comment "All Prod Windows 8.1" -LimitingCollectionName $LimitingCollctionWorkStationProd -RefreshSchedule $Schedule -RefreshType 2 | Out-Null
Add-CMDeviceCollectionQueryMembershipRule -CollectionName $Collection14.Name -QueryExpression $Collection14.Query -RuleName $Collection14.Name
Write-host *** Collection $Collection14.Name created ***

New-CMDeviceCollection -Name $Collection15.Name -Comment "All Dev Windows 7" -LimitingCollectionName $LimitingCollctionWorkstationDev -RefreshSchedule $Schedule -RefreshType 2 | Out-Null
Add-CMDeviceCollectionQueryMembershipRule -CollectionName $Collection15.Name -QueryExpression $Collection15.Query -RuleName $Collection15.Name
Write-host *** Collection $Collection15.Name created ***

New-CMDeviceCollection -Name $Collection16.Name -Comment "All Prod Windows 7" -LimitingCollectionName $LimitingCollctionWorkStationProd -RefreshSchedule $Schedule -RefreshType 2 | Out-Null
Add-CMDeviceCollectionQueryMembershipRule -CollectionName $Collection16.Name -QueryExpression $Collection16.Query -RuleName $Collection16.Name
Write-host *** Collection $Collection16.Name created ***



#Move the collection to the right folder
$WindowsUpdateFolderPath = $SiteCode.Name + ":\DeviceCollection\" + $WindowsUpdateFolder.Name
$ServersFolderPath = $SiteCode.Name + ":\DeviceCollection\" + $ServersFolder.Name
$2008Folder = $SiteCode.Name + ":\DeviceCollection\" + $2008Folder.Name
$2012Folder = $SiteCode.Name + ":\DeviceCollection\" + $2012Folder.Name
$2016Folder = $SiteCode.Name + ":\DeviceCollection\" + $2016Folder.Name
$WorkstationsFolder = $SiteCode.Name + ":\DeviceCollection\" + $WorkstationsFolder.Name
$Win10Folder = $SiteCode.Name + ":\DeviceCollection\" + $Win10Folder.Name
$Win81Folder = $SiteCode.Name + ":\DeviceCollection\" + $Win81Folder.Name
$Win7Folder = $SiteCode.Name + ":\DeviceCollection\" + $Win7Folder.Name

Move-CMObject -FolderPath $ServersFolderPath -InputObject (Get-CMDeviceCollection -Name $Collection1.Name)
Move-CMObject -FolderPath $ServersFolderPath -InputObject (Get-CMDeviceCollection -Name $Collection2.Name)
Move-CMObject -FolderPath $2008Folder -InputObject (Get-CMDeviceCollection -Name $Collection3.Name)
Move-CMObject -FolderPath $2008Folder -InputObject (Get-CMDeviceCollection -Name $Collection4.Name)
Move-CMObject -FolderPath $2012Folder -InputObject (Get-CMDeviceCollection -Name $Collection5.Name)
Move-CMObject -FolderPath $2012Folder -InputObject (Get-CMDeviceCollection -Name $Collection6.Name)
Move-CMObject -FolderPath $2016Folder -InputObject (Get-CMDeviceCollection -Name $Collection7.Name)
Move-CMObject -FolderPath $2016Folder -InputObject (Get-CMDeviceCollection -Name $Collection8.Name)
Move-CMObject -FolderPath $WorkstationsFolder -InputObject (Get-CMDeviceCollection -Name $Collection9.Name)
Move-CMObject -FolderPath $WorkstationsFolder -InputObject (Get-CMDeviceCollection -Name $Collection10.Name)
Move-CMObject -FolderPath $Win10Folder -InputObject (Get-CMDeviceCollection -Name $Collection11.Name)
Move-CMObject -FolderPath $Win10Folder -InputObject (Get-CMDeviceCollection -Name $Collection12.Name)
Move-CMObject -FolderPath $Win81Folder -InputObject (Get-CMDeviceCollection -Name $Collection13.Name)
Move-CMObject -FolderPath $Win81Folder -InputObject (Get-CMDeviceCollection -Name $Collection14.Name)
Move-CMObject -FolderPath $Win7Folder -InputObject (Get-CMDeviceCollection -Name $Collection15.Name)
Move-CMObject -FolderPath $Win7Folder -InputObject (Get-CMDeviceCollection -Name $Collection16.Name)