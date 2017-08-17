#Disable Quick Assist
Get-WindowsPackage -Online | Where PackageName -like *QuickAssist* | Remove-WindowsPackage -Online -NoRestart
#Disable Contant Support Link
Get-WindowsPackage -Online | Where PackageName -like *Support*| Remove-WindowsPackage -Online -NoRestart
#Disable SMB 1
Set-SmbServerConfiguration -EnableSMB1Protocol $false -force
Disable-WindowsOptionalFeature -Online -FeatureName smb1protocol -NoRestart
#Disable People App
Get-AppxPackage -AllUsers | Where-Object {$_.PackageFullName -like "*people*"} | Remove-AppxPackage 
#Disable Music Player
Get-AppxPackage -AllUsers | Where-Object {$_.PackageFullName -like "*zune*"} | Remove-AppxPackage
#Disable Xbox App
Get-AppxPackage -AllUsers  |  Where-Object {$_.PackageFullName -like "*xboxapp*"} | Remove-AppxPackage 
#Disable WIndows Phone, Messaging
Get-AppxPackage -AllUsers  | Where-Object {$_.PackageFullName -like "*windowspho*"} | Remove-AppxPackage
Get-AppxPackage -AllUsers | Where-Object {$_.PackageFullName -like "*messaging*"} | Remove-AppxPackage 
#Disable Skype, Onenote App
Get-AppxPackage -AllUsers  | Where-Object {$_.PackageFullName -like "*skypeap*"} | Remove-AppxPackage
Get-AppxPackage -AllUsers | Where-Object {$_.PackageFullName -like "*onenote*"} | Remove-AppxPackage 
#Disable Get Office
Get-AppxPackage -AllUsers  |  Where-Object {$_.PackageFullName -like "*officehub*"} | Remove-AppxPackage | Remove-AppxPackage 


#this runs within the imaging process and removes all of these apps from the local user (SCCM / local system) and future users
#if it is desired to retain an app in imaging, just place a # comment character at the start of a line

#region remove current user
$packages = Get-AppxPackage -AllUsers

#mail and calendar
$packages | Where-Object {$_.PackageFullName -like "*windowscommun*"}     | Remove-AppxPackage

#social media
$packages | Where-Object {$_.PackageFullName -like "*people*"}            | Remove-AppxPackage 

#microsoft promotions, product discounts, etc
$packages | Where-Object {$_.PackageFullName -like "*surfacehu*"}         | Remove-AppxPackage 

#renamed to Groove Music, iTunes like music player
$packages | Where-Object {$_.PackageFullName -like "*zune*"}              | Remove-AppxPackage 

#gaming themed application
$packages | Where-Object {$_.PackageFullName -like "*xboxapp*"}           | Remove-AppxPackage 

# photo application (many leave this app)
$packages | Where-Object {$_.PackageFullName -like "*windowspho*"}        | Remove-AppxPackage 

#
$packages | Where-Object {$_.PackageFullName -like "*skypeap*"}           | Remove-AppxPackage 

#
$packages | Where-Object {$_.PackageFullName -like "*messaging*"}         | Remove-AppxPackage

# free/office 365 version of oneNote, can confuse users
$packages | Where-Object {$_.PackageFullName -like "*onenote*"}           | Remove-AppxPackage 

# tool to create interesting presentations
$packages | Where-Object {$_.PackageFullName -like "*sway*"}              | Remove-AppxPackage 

# Ad driven game
$packages | Where-Object {$_.PackageFullName -like "*solitaire*"}         | Remove-AppxPackage 

$packages | Where-Object {$_.PackageFullName -like "*commsphone*"}        | Remove-AppxPackage
$packages | Where-Object {$_.PackageFullName -like "*3DBuild*"}           | Remove-AppxPackage
$packages | Where-Object {$_.PackageFullName -like "*getstarted*"}        | Remove-AppxPackage
$packages | Where-Object {$_.PackageFullName -like "*officehub*"}         | Remove-AppxPackage
$packages | Where-Object {$_.PackageFullName -like "*feedbackhub*"}       | Remove-AppxPackage

# Connects to your mobile phone for notification mirroring, cortana services
$packages | Where-Object {$_.PackageFullName -like "*oneconnect*"}        | Remove-AppxPackage
#endregion

#region remove provisioning packages (Removes for future users)
$appProvisionPackage = Get-AppxProvisionedPackage -Online

$appProvisionPackage | Where-Object {$_.DisplayName -like "*windowscommun*"} | Remove-AppxProvisionedPackage -Online
$appProvisionPackage | Where-Object {$_.DisplayName -like "*people*"}        | Remove-AppxProvisionedPackage -Online
$appProvisionPackage | Where-Object {$_.DisplayName -like "*surfacehu*"}     | Remove-AppxProvisionedPackage -Online
$appProvisionPackage | Where-Object {$_.DisplayName -like "*zune*"}          | Remove-AppxProvisionedPackage -Online
$appProvisionPackage | Where-Object {$_.DisplayName -like "*xboxapp*"}       | Remove-AppxProvisionedPackage -Online
$appProvisionPackage | Where-Object {$_.DisplayName -like "*windowspho*"}    | Remove-AppxProvisionedPackage -Online
$appProvisionPackage | Where-Object {$_.DisplayName -like "*skypeap*"}       | Remove-AppxProvisionedPackage -Online
$appProvisionPackage | Where-Object {$_.DisplayName -like "*messaging*"}     | Remove-AppxProvisionedPackage -Online
$appProvisionPackage | Where-Object {$_.DisplayName -like "*onenote*"}       | Remove-AppxProvisionedPackage -Online
$appProvisionPackage | Where-Object {$_.DisplayName -like "*sway*"}          | Remove-AppxProvisionedPackage -Online
$appProvisionPackage | Where-Object {$_.DisplayName -like "*solitaire*"}     | Remove-AppxProvisionedPackage -Online
$appProvisionPackage | Where-Object {$_.DisplayName -like "*commsphone*"}    | Remove-AppxProvisionedPackage -Online
$appProvisionPackage | Where-Object {$_.DisplayName -like "*3DBuild*"}       | Remove-AppxProvisionedPackage -Online
$appProvisionPackage | Where-Object {$_.DisplayName -like "*getstarted*"}    | Remove-AppxProvisionedPackage -Online
$appProvisionPackage | Where-Object {$_.DisplayName -like "*officehub*"}     | Remove-AppxProvisionedPackage -Online
$appProvisionPackage | Where-Object {$_.DisplayName -like "*feedbackhub*"}   | Remove-AppxProvisionedPackage -Online
$appProvisionPackage | Where-Object {$_.DisplayName -like "*oneconnect*"}    | Remove-AppxProvisionedPackage -Online
#endregion

<#restoration howto
To rol back the Provisioning Package removal, image a machine with an ISO and then copy the source files from
the c:\Program File\WindowsApps directory.  There should be three folders per Windows 10 app.  These need to
be distributed w/ SCCM to the appropriate place, and then run
    copy-item .\* c:\Appx
    Add-AppxProvisionedPackage -Online �FolderPath c:\Appx

    $manifestpath = "c:\appx\*Appxmanifest.xml"
    PS C:\> Add-AppxPackage -register $manifestpath �DisableDevelopmentMode
#>

#removes the Windows Fax feature but requires a reboot, returning a 3010 errorlevel.  Ignore this error
cmd /c dism /online /disable-feature /featurename:FaxServicesClientPackage /remove /NoRestart
