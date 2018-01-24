$CurrentDate = Get-Date
$CurrentDate = $CurrentDate.ToString('MM-dd-yyyy_hh-mm-ss')
#$LogTime = Get-Date -Format "MM-dd-yy"
get-aduser -filter * -Properties whencreated,LastLogonDate,logoncount | select Name,whencreated,Lastlogondate,logoncount | sort name | Export-csv -Path "C:\Temp\ADusers_$CurrentDate.csv" 
