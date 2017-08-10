<#
	Changing the variables below will allow you to target other
	collections or lists of computers when needed.
	
	Use Get-CMCollection | Export-CSV <Destination> to get a list
	of all Collections that currently exist in SCCM.
#>

#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#REQUIRED FOR SCCM SCRIPTS
#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
$SCCMSitePath = "<SITECODE>"
Import-Module (Join-Path $(Split-Path $env:SMS_ADMIN_UI_PATH) ConfigurationManager.psd1)
#Set current directory to SCCM site
Set-Location -Path $SCCMSitePath
#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

# Tell Powershell to ignore any errors that may fill up the screen.
$ErrorActionPreference = 'silentlycontinue'

##########################################################################
#VARIABLES
##########################################################################
$TextFile = <Path To TextFile>
$CollectionID = <ID of Collection>
##########################################################################

$ComputerList = Get-Content $TextFile

Foreach($Computer in $ComputerList)
{
	Write-Host $Computer -Foreground green -Background Black
	Add-CMDeviceCollectionDirectMembershipRule -CollectionID $CollectionID `
		-ResourceId $(Get-CMDevice -Name $Computer).ResourceID
}

Write-Host "Complete" -Foreground magenta -Background black
Write-Host ""