##USAGE##
#### Add Function Call for AddCollectionSettings Function declaring respective variables
#### i.e., AddCollectionSettings ADGroupName "ColletionName" "ConneectionnBrokerName" "webURL" "rdpFileLocation" "domainFQDN" "NuveCenter" "SecurityThumbprint-probably AAD59E96B1A568ABE20A927E5A7F1FBB61AA557B"
#### Comment out or remove any instances of AddCollectionSettings you do not want to set.
#### . .\addCollectionFunc.ps1
#
##ACCESS##
####Account must have access to change specified groups in Active Directory
#
##NOTES##
####Seperate credentials can be used. Must uncomment all settings related to $cred
######Declaring $cred value
######When using Set-ADGroup command

#Declare variables
#$cred = Get-Credential

#AddCollectionSettings - Function adds indicated Remote Desktop collection settings as attributes on AD group
Function AddCollectionSettings{
    #Define Required parameters -
    #Required - If missing script will prompt for them. If running silently this will cause script to pause because its waiting for input.
    Param(
        [Parameter(Mandatory=$True)]
        [string]$groupName,

        [Parameter(Mandatory=$True)]
        [string]$resourceName,
		
        [Parameter(Mandatory=$True)]
        [string]$broker,	
		
        [Parameter(Mandatory=$True)]
        [string]$rdWeb,
        
        [Parameter(Mandatory=$True)]
        [string]$rdpFilePath,
        
        [Parameter(Mandatory=$True)]
        [string]$domainFQDN,
        
        [Parameter(Mandatory=$True)]
        [string]$tenantcode,
        
        [Parameter(Mandatory=$True)]
        [string]$securitythumbprint
    )

    #Pull group information to show initial settings
    Write-Host "Initial settings"
    Get-ADGroup -Identity $groupName -Server $domainFQDN -Properties extensionAttribute2,displayName,desktopProfile,wwwHomePage,extensionAttribute3 #,extensionData  #- extensionData attribute is not readable, uncomment to show anyway


    #Pull group information from AD
    $group = Get-ADGroup -Identity $groupName -Server $domainFQDN

    #Validate that group exists, set attributes if it does, error message if not
    if ($group -ne $null){
        #Convert RDP File to text
        $enc = [system.Text.Encoding]::UTF8
        $rdpText =  [System.IO.File]::ReadAllText($rdpFilePath)
        $rdpBits= $enc.GetBytes($rdpText)
        
        #Set attributes on AD group
        $group | Set-ADGroup -Replace @{displayName=$resourceName;desktopProfile=$broker;wwwHomePage=$rdweb;extensionData=$rdpBits;extensionAttribute2=$tenantcode;extensionAttribute3=$securitythumbprint} #-Credential $cred
        
        #Pull group information to verify change
        Write-Host "Settings after change"
        Get-ADGroup -Identity $groupName -Server $domainFQDN -Properties extensionAttribute2,displayName,desktopProfile,wwwHomePage,extensionAttribute3 #,extensionData  #- extensionData attribute is not readable, uncomment to show anyway
    }
    #Produce error message if group does not exist
    Else{
        Write-Host "Group $groupName not found"
        return 
    }
}

#AddCollectionSettings NUVE-RDS-BALLETWEST_DL "Ballet West" "TONBROKER.NUVESTACK.COM" "https://tonweb.nuvestack.com" "C:\Users\mmaas_ad\Desktop\rdp\cpub-Ballet_West-Ballet_West-CmsRdsh.rdp" "nuvestack.com" "BALLETWEST" "AAD59E96B1A568ABE20A927E5A7F1FBB61AA557B"
#AddCollectionSettings NUVE-RDS-BOM_DL "Bommarito" "BOMBROKER.NUVESTACK.COM" "https://bomweb.nuvestack.com" "C:\Users\mmaas_ad\Desktop\rdp\cpub-The_Benefits_Gro-The_Benefits_Gro-CmsRdsh.rdp" "nuvestack.com" "BOMMARITO" "AAD59E96B1A568ABE20A927E5A7F1FBB61AA557B"
#AddCollectionSettings NUVE-RDS-MYDESKTOP_DL "MyDesktop" "TONBROKER.NUVESTACK.COM" "https://tonweb.nuvestack.com" "C:\Users\mmaas_ad\Desktop\rdp\cpub-My_Desktop-My_Desktop-CmsRdsh.rdp" "nuvestack.com" "MYDESKTOP" "AAD59E96B1A568ABE20A927E5A7F1FBB61AA557B"
#AddCollectionSettings NUVE-RDS-Nuvestack "Nuvestack" "TONBROKER.NUVESTACK.COM" "https://tonweb.nuvestack.com" "C:\Users\mmaas_ad\Desktop\rdp\cpub-Nuvestack-Nuvestack-CmsRdsh.rdp" "nuvestack.com" "NUVESTACK" "AAD59E96B1A568ABE20A927E5A7F1FBB61AA557B"
#AddCollectionSettings NUVE-RDS-AllCollections_DL "Tonaquint Admin Collection" "TONBROKER.NUVESTACK.COM" "https://tonweb.nuvestack.com" "C:\Users\mmaas_ad\Desktop\rdp\cpub-Tonaquint_Admin-Tonaquint_Admin-CmsRdsh.rdp" "nuvestack.com" "TONAQUINTADMIN" "AAD59E96B1A568ABE20A927E5A7F1FBB61AA557B"
#AddCollectionSettings NUVE-RDS-AccessData_DL "AccessData" "TONBROKER.NUVESTACK.COM" "https://tonweb.nuvestack.com" "C:\Users\mmaas_ad\Desktop\rdp\cpub-Access_Data_Demo-Access_Data_Demo-CmsRdsh.rdp" "nuvestack.com" "ACCESSDATA" "AAD59E96B1A568ABE20A927E5A7F1FBB61AA557B"
AddCollectionSettings DL_RDS_TonTrial_NUVE_RA "Trial" "TONBROKER.NUVESTACK.COM" "https://tonweb.nuvestack.com" "C:\Users\tmount_ad\Desktop\cpub-Trial-Trial-CmsRdsh.rdp" "nuvestack.com" "TRIAL" "AAD59E96B1A568ABE20A927E5A7F1FBB61AA557B"
#AddCollectionSettings NUVE-RDS-Crown_DL "Crown" "CROWNBROKER.NUVESTACK.COM" "https://crownweb.nuvestack.com" "C:\Users\mmaas_ad\Desktop\rdp\cpub-Crown_Capital-Crown_Capital-CmsRdsh.rdp" "nuvestack.com" "CROWNCAPITAL" "AAD59E96B1A568ABE20A927E5A7F1FBB61AA557B"
#AddCollectionSettings NUVE-RDS-GST_DL "GST" "NUVEBROKER.NUVESTACK.COM" "https://viaweb.nuvestack.com" "C:\Users\mmaas_ad\Desktop\rdp\cpub-GST_Collection-GST_Collection-CmsRdsh.rdp" "nuvestack.com" "GST" "AAD59E96B1A568ABE20A927E5A7F1FBB61AA557B"
#AddCollectionSettings NUVE-RDS-WGU_DL "WGU" "NUVEBROKER.NUVESTACK.COM" "https://viaweb.nuvestack.com" "C:\Users\mmaas_ad\Desktop\rdp\cpub-Western_Governor-Western_Governor-CmsRdsh.rdp" "nuvestack.com" "WESTERNGOVERNORS" "AAD59E96B1A568ABE20A927E5A7F1FBB61AA557B"
#AddCollectionSettings NUVE-RDS-BYU_DL "BYU" "NUVEBROKER.NUVESTACK.COM" "https://viaweb.nuvestack.com" "C:\Users\mmaas_ad\Desktop\rdp\cpub-BYU_POC_Collecti-BYU_POC_Collecti-CmsRdsh.rdp" "nuvestack.com" "BYU" "AAD59E96B1A568ABE20A927E5A7F1FBB61AA557B"
#AddCollectionSettings DL_RDSAceAdmin_NUVE_RA "Ace Admin" "NUVEBROKER.NUVESTACK.COM" "https://viaweb.nuvestack.com" "C:\Users\mmaas_ad\Desktop\rdp\cpub-Nuvestack_Admini-Nuvestack_Admini-CmsRdsh.rdp" "nuvestack.com" "ACEADMIN" "AAD59E96B1A568ABE20A927E5A7F1FBB61AA557B"
#AddCollectionSettings DL_RDSTonAdmin_NUVE_RA "Ton Admin" "NUVEBROKER.NUVESTACK.COM" "https://viaweb.nuvestack.com" "C:\Users\mmaas_ad\Desktop\rdp\cpub-Tonaquint_Admin-Tonaquint_Admin-CmsRdsh.rdp" "nuvestack.com" "TONADMIN" "AAD59E96B1A568ABE20A927E5A7F1FBB61AA557B"
#AddCollectionSettings DL_RDS_NuveDev_NUVE_RA "Development Environment" "NUVEBROKER.NUVESTACK.COM" "https://viaweb.nuvestack.com" "C:\Users\tmount_ad\Desktop\RDP\cpub-Development_Envi-Development_Envi-CmsRdsh.rdp" "nuvestack.com" "NUVESTACK" "AAD59E96B1A568ABE20A927E5A7F1FBB61AA557B"
#AddCollectionSettings DL_RDS_NuveDevCR_NUVE_RA "Costica Rica Developer Server" "CR02RDCB02.NUVESTACK.COM" "https://miescritorio.nuvestack.cr" "C:\Users\tmount_ad\Desktop\RDP\cpub-Costica_Rica_Dev-Costica_Rica_Dev-CmsRdsh.rdp" "nuvestack.com" "NUVESTACK" "AAD59E96B1A568ABE20A927E5A7F1FBB61AA557B"
#AddCollectionSettings DL_RDS_NuveDevCR_NUVE_RA "Costica Rica Developer Server" "CR02RDCB02.NUVESTACK.COM" "https://tonweb.nuvestack.com" "C:\Users\tmount_ad\Desktop\cpub-Trial-Trial-CmsRdsh.rdp" "nuvestack.com" "TRIAL" "AAD59E96B1A568ABE20A927E5A7F1FBB61AA557B"