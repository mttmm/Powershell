$csv = gc C:\temp\___DOWN.txt
$error.clear()
Foreach($comp in $csv){
Try{
Get-ADComputer $comp | Select-Object Name,Enabled,distinguishedname | fl | Out-File C:\temp\cannotfindadobject.txt -Append}
Catch
{
#Write-Warning "$comp was not found in Active Directory"
}
}
$error.exception | Out-File c:\temp\cannotfindadobject.txt -Append

