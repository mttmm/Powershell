$objSID = New-Object System.Security.Principal.SecurityIdentifier `
    ("S-1-5-21-3524705681-4103909615-4221205055-1270")
$objUser = $objSID.Translate( [System.Security.Principal.NTAccount])
$objUser.Value