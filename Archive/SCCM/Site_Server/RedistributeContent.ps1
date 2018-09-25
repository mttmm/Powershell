#
# Press 'F5' to run this script. Running this script will load the ConfigurationManager
# module for Windows PowerShell and will connect to the site.
#
# This script was auto-generated at '8/17/2017 9:55:05 AM'.

# Uncomment the line below if running in an environment where script signing is 
# required.
#Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process

Import-Module "$($ENV:SMS_ADMIN_UI_PATH)\..\ConfigurationManager.psd1" # Import the ConfigurationManager.psd1 module 
Set-Location "MJM:" # Set the current location to be the site code.
$Sitecode = 'MJM'

Get-CMPackage | Select -ExpandProperty PackageID | ForEach-Object {
$package = $_
Write-host "Adding Package: $package"
if (((Get-WMIObject -NameSpace "Root\SMS\Site_$Sitecode" -Class SMS_DistributionPointGroup).RedistributePackage($package)).ReturnValue -ne 0)
{
Write-host -ForegroundColor DarkRed "Possible error processing $package"
}
ELSE{
Write-Host -ForegroundColor GREEN "Success!"
}
}