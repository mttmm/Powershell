#help Get-ADGroup -Examples
#help Get-ADGroupMember -Examples

$collection = @()
$DLGroup = Get-ADGroup -Filter 'GroupCategory -eq "Distribution"'
$DLGroup | foreach{
    $groupaddress = 
    $Groupname = $_.name
    $members = Get-ADGroupMember $_ | select Name,samaccountname
    $members | foreach{
        $member = $_.Name
        $sam = $_.samaccountname
$coll = "" | Select ADGroupName,MemberName,SamAccountName
$coll.ADGroupName = $Groupname
$coll.MemberName = $member
$coll.SamAccountName = $sam
$collection +=$coll
    }
}

$collection | export-csv -Path c:\temp\members1.csv -NoTypeInformation