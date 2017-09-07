Get-ADDomainController -Discover:$true -DomainName:"MTTMMTECH" -ForceDiscover:$true -Service:ADWS -Writable:$true
New-ADOrganizationalUnit -Name:"Servers" -Path:"DC=mttmmtech,DC=com" -ProtectedFromAccidentalDeletion:$true -Server:"DC01.mttmmtech.com"
Set-ADObject -Identity:"OU=Servers,DC=mttmmtech,DC=com" -ProtectedFromAccidentalDeletion:$true -Server:"DC01.mttmmtech.com"
