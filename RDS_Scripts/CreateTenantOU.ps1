# Creates User and RDSH Server OUs

$ouNames = @("JAN")

foreach ($ouName in $ouNames) {
New-ADOrganizationalUnit -Name $ouName -Path "OU=RDSH,OU=SERVERS,DC=nuvestack,DC=COM"
New-ADOrganizationalUnit -Name $ouName -Path "OU=Tenants,DC=nuvestack,DC=COM"
}