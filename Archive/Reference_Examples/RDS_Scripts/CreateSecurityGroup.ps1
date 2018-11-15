$DLgroupnames = @(“BAL-RaisersEdge7.93_GG”)

$DestOU = “OU=Tenants,DC=nuvestack,DC=com”

foreach ($DLgroupname in $DLgroupnames) {
NEW-ADGroup –name $DLgroupname –groupscope global –path $DestOU
}

