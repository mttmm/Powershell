#get SID for a given user
Get-ADUser -Identity ad.user | Select-Object -Property Name, SID
#Get the user for a given SID
Get-ADUser -Filter * | Select-Object -Property SID, Name | Where-Object -Property SID -like "*-6640"

Get-ADUser -Identity "citiustst" | Select-Object -Property Name, SID