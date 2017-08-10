Function AddCollectionSettings{
param([string]$groupName, [string]$resourceName, [string]$broker,[string]$rdWeb, [string]$rdpFilePath, [string]$server, [string]$tenantcode, [PSCredential]$cred)

$group = Get-ADGroup -Identity $groupName -Server $server

if ($group -eq $null)
    {
        Write-Host "Group $groupName not found"
        return 
    }

    $enc = [system.Text.Encoding]::UTF8
    $rdpText =  [System.IO.File]::ReadAllText($rdpFilePath)
    $rdpBits= $enc.GetBytes($rdpText)

    
    $uri = $rdWeb + "/rdweb"
    $r = Invoke-WebRequest -URI $uri -Credential $cred
    $certField = $r.InputFields | where {$_.name -eq "RDPCertificates"}
    $cert = $certField.value
    write-host "cert: $cert"

    $group | Set-ADGroup -Replace @{displayName=$resourceName;desktopProfile=$broker;wwwHomePage=$rdweb;extensionData=$rdpBits;extensionAttribute2=$tenantcode}
    Get-ADGroup -Identity $groupName -Server $server
}


##  USAGE:
#
# . .\addCollectionFunc.ps1
#
#$cred = Get-Credential

#AddCollectionSettings NUVE-RDS-BALLETWEST_DL "BalletWest" "TONBROKER.NUVESTACK.COM" "https://tonweb.nuvestack.com" "C:\Users\mmaas_ad\Desktop\rdp\cpub-Ballet_West-Ballet_West-CmsRdsh.rdp" "nuvestack.com" "BALLETWEST"
#AddCollectionSettings NUVE-RDS-BOM_DL "Bommarito" "BOMBROKER.NUVESTACK.COM" "https://bomweb.nuvestack.com" "C:\Users\mmaas_ad\Desktop\rdp\cpub-The_Benefits_Gro-The_Benefits_Gro-CmsRdsh.rdp" "nuvestack.com" "BOMMARITO"
#AddCollectionSettings NUVE-RDS-MYDESKTOP_DL "MyDesktop" "TONBROKER.NUVESTACK.COM" "https://tonweb.nuvestack.com" "C:\Users\mmaas_ad\Desktop\rdp\cpub-My_Desktop-My_Desktop-CmsRdsh.rdp" "nuvestack.com" "MYDESKTOP"
#AddCollectionSettings NUVE-RDS-Nuvestack "Nuvestack" "TONBROKER.NUVESTACK.COM" "https://tonweb.nuvestack.com" "C:\Users\mmaas_ad\Desktop\rdp\cpub-Nuvestack-Nuvestack-CmsRdsh.rdp" "nuvestack.com" "NUVESTACK"
#AddCollectionSettings NUVE-RDS-AllCollections_DL "Tonaquint Admin Collection" "TONBROKER.NUVESTACK.COM" "https://tonweb.nuvestack.com" "C:\Users\mmaas_ad\Desktop\rdp\cpub-Tonaquint_Admin-Tonaquint_Admin-CmsRdsh.rdp" "nuvestack.com" "TONAQUINTADMIN"
#AddCollectionSettings NUVE-RDS-AccessData_DL "AccessData" "TONBROKER.NUVESTACK.COM" "https://tonweb.nuvestack.com" "C:\Users\mmaas_ad\Desktop\rdp\cpub-Access_Data_Demo-Access_Data_Demo-CmsRdsh.rdp" "nuvestack.com" "ACCESSDATA"
#AddCollectionSettings NUVE-RDS-Trial_DL "Trial" "TONBROKER.NUVESTACK.COM" "https://tonweb.nuvestack.com" "C:\Users\mmaas_ad\Desktop\rdp\cpub-Trial-Trial-CmsRdsh.rdp" "nuvestack.com" "TRIAL"
#AddCollectionSettings NUVE-RDS-Crown_DL "Crown" "CROWNBROKER.NUVESTACK.COM" "https://crownweb.nuvestack.com" "C:\Users\mmaas_ad\Desktop\rdp\cpub-Crown_Capital-Crown_Capital-CmsRdsh.rdp" "nuvestack.com" "CROWNCAPITAL"
#AddCollectionSettings NUVE-RDS-GST_DL "GST" "NUVEBROKER.NUVESTACK.COM" "https://viaweb.nuvestack.com" "C:\Users\mmaas_ad\Desktop\rdp\cpub-GST_Collection-GST_Collection-CmsRdsh.rdp" "nuvestack.com" "GST"
#AddCollectionSettings NUVE-RDS-WGU_DL "WGU" "NUVEBROKER.NUVESTACK.COM" "https://viaweb.nuvestack.com" "C:\Users\mmaas_ad\Desktop\rdp\cpub-Western_Governor-Western_Governor-CmsRdsh.rdp" "nuvestack.com" "WESTERNGOVERNORS"
#AddCollectionSettings NUVE-RDS-BYU_DL "BYU" "NUVEBROKER.NUVESTACK.COM" "https://viaweb.nuvestack.com" "C:\Users\mmaas_ad\Desktop\rdp\cpub-BYU_POC_Collecti-BYU_POC_Collecti-CmsRdsh.rdp" "nuvestack.com" "BYU"y