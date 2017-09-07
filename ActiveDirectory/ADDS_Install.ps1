<#


# Windows PowerShell script for AD DS Deployment
#>


#install-windowsfeature ad-domain-services -includemanagementtools


Import-Module ADDSDeployment
Install-ADDSForest `
-CreateDnsDelegation:$false `
-DatabasePath "C:\Windows\NTDS" `
-DomainMode "WinThreshold" `
-DomainName "mttmmtech.com" `
-DomainNetbiosName "MTTMMTECH" `
-ForestMode "WinThreshold" `
-InstallDns:$true `
-LogPath "C:\Windows\NTDS" `
-NoRebootOnCompletion:$false `
-SysvolPath "C:\Windows\SYSVOL" `
-Force:$true
