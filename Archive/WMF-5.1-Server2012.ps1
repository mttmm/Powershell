set-executionpolicy unrestricted

if ($PSVersionTable.PSVersion.Major -lt 5) {
    write-host "PowerShell is not version 5.x. Updating PowerShell now..."
    if (!(test-path  C:\Temp)){New-Item -Path c:\test -ItemType directory}
    robocopy \\crcfpa01.columbusrad.local\it\Software\Microsoft\WMF-5.1 C:\Temp Win8.1AndW2K12R2-KB3191564-x64.msu

    C:\Temp\Win8.1AndW2K12R2-KB3191564-x64.msu}

    Find-Module -Name xActiveDirectory, xComputerManagement, xNetworking | Install-Module -SkipPublisherCheck -Force