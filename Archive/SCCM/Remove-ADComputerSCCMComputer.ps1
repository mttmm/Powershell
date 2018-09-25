$compname = 'test'
Import-Module ConfigurationManager -Function Get-PSDrive Remove-CMDevice
Import-Module ActiveDirectory -Function Remove-ADObject

try {
    Write-output "Searching for $compname"
    $comp = Get-ADComputer $compname -ErrorAction Continue
}
catch {
    Write-Output "AD Computer $compname was not found"
    $comp = $null
}

if ($comp.distinguishedname -ne $null){
    Write-Output "Removing $compname from Active Directory"
    $comp.DistinguishedName | Remove-ADObject -Recursive -Confirm:$false
    Write-Output "$compname has been removed"
}
else{
}

try {
    Write-Output "Removing $compname from ConfigMgr"
    $PSD = Get-PSDrive -PSProvider CMSite
    Set-Location "$($PSD):"
    Remove-CMDevice -Name $compname -confirm:$false -Force -ErrorAction Stop
    Write-Output "$compname has been removed from ConfigMgr"
    }
catch {
    Write-Output "$compname was not found in the ConfigMgr database"
}
Set-Location "C:"