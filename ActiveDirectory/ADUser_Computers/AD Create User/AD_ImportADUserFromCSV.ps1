﻿Import-Csv C:\temp\usercreationfile.csv | foreach-object { 
$userprinicpalname = $_.SamAccountName + "@CrownCapital.net" 
New-ADUser -SamAccountName $_.SamAccountName -UserPrincipalName $userprinicpalname -Name $_.NAME -DisplayName $_.NAME -GivenName $_.CN -SurName $_.SN -Department $_.Department -Path $_.Path -AccountPassword (ConvertTo-SecureString "Crowncap1" -AsPlainText -force) -Enabled $True -PasswordNeverExpires $False -PassThru }