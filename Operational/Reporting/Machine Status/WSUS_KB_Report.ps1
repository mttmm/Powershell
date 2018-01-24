Function GetUpdateState {
param([string[]]$kbnumber,
[string]$wsusserver,
[string]$port
)
$report = @()
[void][reflection.assembly]::LoadWithPartialName("Microsoft.UpdateServices.Administration")
$wsus = [Microsoft.UpdateServices.Administration.AdminProxy]::getUpdateServer($wsusserver,$False,8530)
$CompSc = new-object Microsoft.UpdateServices.Administration.ComputerTargetScope
$updateScope = new-object Microsoft.UpdateServices.Administration.UpdateScope; 
$updateScope.UpdateApprovalActions = [Microsoft.UpdateServices.Administration.UpdateApprovalActions]::Install
foreach ($kb in $kbnumber){ #Loop against each KB number passed to the GetUpdateState function 
   $updates = $wsus.GetUpdates($updateScope) | ?{$_.Title -match $kb} #Getting every update where the title matches the $kbnumber
       foreach($update in $updates){ #Loop against the list of updates I stored in $updates in the previous step
          $update.GetUpdateInstallationInfoPerComputerTarget($CompSc) | ?{$_.UpdateApprovalAction -eq "Install"} |  % { #for the current update
#Getting the list of computer object IDs where this update is supposed to be installed ($_.UpdateApprovalAction -eq "Install")
          $Comp = $wsus.GetComputerTarget($_.ComputerTargetId)# using #Computer object ID to retrieve the computer object properties (Name, #IP address)
 
          $info = "" | select UpdateTitle, LegacyName, SecurityBulletins, Computername, OS ,IpAddress, UpdateInstallationStatus, UpdateApprovalAction #Creating a custom PowerShell object to store the information
          $info.UpdateTitle = $update.Title
          $info.LegacyName = $update.LegacyName
          $info.SecurityBulletins = ($update.SecurityBulletins -join ';')
          $info.Computername = $Comp.FullDomainName
          $info.OS = $Comp.OSDescription
          $info.IpAddress = $Comp.IPAddress
          $info.UpdateInstallationStatus = $_.UpdateInstallationState
          $info.UpdateApprovalAction = $_.UpdateApprovalAction
          $report+=$info # Storing the information into the $report variable 
        }
     }
  }
$report | ?{$_.UpdateInstallationStatus -ne 'NotApplicable' -and $_.UpdateInstallationStatus -ne 'Unknown' -and $_.UpdateInstallationStatus -ne 'Installed' } |  Export-Csv -Path c:\temp\rep_wsus.csv -Append -NoTypeInformation
} #Filtering the report to list only computers where the updates are not installed
 
$MS17010 = "4012212","4012598","4012215","4012213","4012216","4012214","4012217","4012606","4013198","4013429"
$CVE20170162 = "4015221","4015219","4015217","4015583","4015550","4015547"
$CVE20170261 = "3118310","3172458","3114375"
 
GetUpdateState -kbnumber $MS17010 -wsusserver dassocsccmpsp01.css.id.ohio.gov -port 8530