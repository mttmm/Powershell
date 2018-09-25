Get-ItemProperty HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters
    #Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" SMB1 -Type DWORD -Value 0 –Force
Get-ItemProperty HKLM:\SYSTEM\CurrentControlSet\Services\mrxsmb10
    #Set-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Services\mrxsmb10" -Name 'Start' -Value "4"
       #Set-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Services\mrxsmb10" -Name 'Start' -Value "2"

Get-ItemProperty  hklm:\SYSTEM\CurrentControlSet\Services\LanmanWorkstation
   #Set-ItemProperty hklm:\SYSTEM\CurrentControlSet\Services\LanmanWorkstation -Name "DependOnService" -Value ("Bowser","MRxSMB20","NSI")



Get-SmbServerConfiguration | select enablesmb1protocol

#Set-SmbServerConfiguration -EnableSMB1Protocol $False -Force
#Set-SmbServerConfiguration -EnableSMB1Protocol $True -Force
#Disable-WindowsOptionalFeature -Online -FeatureName SMB1Protocol

#For Windows Server
# Remove-WindowsFeature FS-SMB1
