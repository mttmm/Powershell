# Author:  Matt Maas 1/3/2017
# Checks for an Altiris agent path and begins the uninstall process if it exists, deletes the remaining folders and Reg keys.  Line 23 returns a True/False if successful.

## If run manually, this must be ran as administrator ##

$Path = 'C:\Program Files\Altiris\Altiris Agent\AeXAgentUtil.exe'
$HKEY = 'HKLM:\Software\Altiris'
$PathExist = Test-Path $Path
$HKEYExist = Test-Path $HKEY
$arguments = '/clean'
if ($PathExist -eq "True"){
    Start-Process $Path -ArgumentList $arguments -PassThru -Wait
    Start-Sleep -Seconds 20

    Get-ChildItem -Directory 'C:\Program Files'  |  where{$_.Name -eq "Altiris"} | Remove-Item -Recurse
}
 if ($HKEYExist -eq "True"){

        Remove-Item $HKEY -Recurse
}
else {
        exit
}
$?