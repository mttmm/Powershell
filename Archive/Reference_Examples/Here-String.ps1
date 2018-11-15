$Computers = 
@"
    Server01
    Server02
Server03.mydomain.local
    Server06
    Server07
  Server08
    Server09
    Server26
    Server27
        Server28
    Server29
         Server30.mydomain.local
    Server35
    Server36
    Server45
    Server46
    Server112
Server113
    Server114 
"@
 
# Here we will set the source and remote share location and path
$SourceDir = "D:\Software\Datadog\v5.8.5-x64-privatefix"
$RemoteSharePath = "D$\Software\Datadog"
 
# Loop through the Here-String, trim each line and build the ComputersArray
$ComputersArray = @()
$Computers.Split("`n") | % { if ($_.Trim()) { $ComputersArray += $_.Trim()  } }
$AllRemoteSharePathsExist = $True
 
# Do a precheck to see if all the remote directories are reachable and exist
$ComputersArray | % { 
    If ((Test-Path "\\$_\$RemoteSharePath") -eq $False) {
        Write-Host -ForegroundColor Red "[PreCheck Error] \\$_\$RemoteSharePath does not exist"
        $AllRemoteSharePathsExist = $False       
    }
}
 
# If the precheck passes, then copy and overwrite existing files
If ($AllRemoteSharePathsExist) {
    $ComputersArray | % { Write-Host "[$_] Copying $SourceDir to \\$_\$RemoteSharePath"; Copy-Item -Path "$SourceDir" -Destination "\\$_\$RemoteSharePath" -Recurse -Force }
} Else {
    Write-Host "Errors Exist, Exiting"
}     