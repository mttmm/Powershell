##USAGE##
## Function to grab files from a specified path and email to a specified recepient from the support email address

######!!!!  The command below needs to be run before anything else.  Only run this line one time.  This prompts the user for a password, encrypts it and stores it in a .txt file so this script can be run unattended

#Read-Host -AsSecureString | ConvertFrom-SecureString | Out-File .\securestring.txt

#SendEmailMessage - Function 
Function SendEmailMessage{
    Param(
        [Parameter(Mandatory=$True)]
        [string]$Path,

        [Parameter(Mandatory=$True)]
        [string]$Recepient

)

#Searches the desired  path for files.  Selects properties and exports.
Write-Host "Compliling Document Report"
Get-ChildItem $Path | Select-Object Name,LastWriteTime | Export-Csv .\Backupreport.csv -NoTypeInformation

#Reads the contents of the encrypted password and applies to variable
$pass = Get-Content .\securestring.txt | ConvertTo-SecureString

#Uses the support O365 email account and password
$creds = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList "support@nuvestack.com",$pass

#Sends message from O365
Write-Host "Sending Message"
Send-MailMessage -to $Recepient -From "Support <support@nuvestack.com>" -Subject "Weekly Data Backup" -Body "This is a weekly data copy report.  If you recieve this message in error, or have any questions please contact Nuvestack support.  Thank you." -Attachments .\Backupreport.csv -SmtpServer "smtp.office365.com" -usessl -Credential $creds -DeliveryNotificationOption OnFailure

}


#SendEmailMessage \\devscale.dev.nuvestack.com\test "mmaas@nuvestack.com"