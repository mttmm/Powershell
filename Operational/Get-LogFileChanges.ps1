<#
.SYNOPSIS
  Name: Get-LogFileChanges.ps1
  The purpose of this script is to monitor and inform you when there is new information in a log file.

.DESCRIPTION
  This is a simple script that needs to be configured as a Scheduled task or schedule job in order to
  monitor a specific log file and any additional entry.

.RELATED LINKS
  https://www.sconstantinou.com

.NOTES
  Version: 1.0

  Release Date: 06-09-2018

  Author: Stephanos Constantinou

.EXAMPLE
  Run the Get-LogFileChanges.ps1 script.
  .\Get-LogFileChanges.ps1
#>

$PasswordFile = "C:\Scripts\Password.txt"
$Key = (1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32)
$EmailUser = "Script-User@domain.com"
$Password = Get-Content $PasswordFile | ConvertTo-SecureString -Key $Key
$EmailCredentials = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $EmailUser,$Password
$To = 'User1@domain.com','User2@domain.com'
$From = 'Script-User@domain.com'
$LogFile = "C:\SourcePath\LogFile.log"
$CheckFile = "C:\Scripts\Files\CheckFile.txt"
$EmailResult = ""
$OldLogContent = Get-Content -Path $CheckFile
$NewLogContent = Get-Content -Path $LogFile
$Difference = Compare-Object $OldLogContent $NewLogContent

$PasswordFile = "C:\Scripts\Password.txt"
$Key = (5,10,20,40,80,160,2,4,8,16,32,64,128,3,6,12,24,48,96,192,7,14,28,56,112,224,9,18,36,72,144,1)
$EmailUser = "ITOperations-Monitoring@bs-shipmanagement.com"
$Password = Get-Content $PasswordFile | ConvertTo-SecureString -Key $Key
$EmailCredentials = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $EmailUser,$Password
$To = 'stephanos.constantinou@bs-shipmanagement.com'
$From = 'ITOperations-Monitoring@bs-shipmanagement.com'

$EmailUp = @"
<style>

body { font-family:Segoe, "Segoe UI", "DejaVu Sans", "Trebuchet MS", Verdana, sans-serif !important; color:#434242;}
TABLE { font-family:Segoe, "Segoe UI", "DejaVu Sans", "Trebuchet MS", Verdana, sans-serif !important; border-width: 1px;border-style: solid;border-color: black;border-collapse: collapse;}
TR {border-width: 1px;padding: 10px;border-style: solid;border-color: white; }
TD {font-family:Segoe, "Segoe UI", "DejaVu Sans", "Trebuchet MS", Verdana, sans-serif !important; border-width: 1px;padding: 10px;border-style: solid;border-color: white; background-color:#C3DDDB;}
.colorm {background-color:#58A09E; color:white;}
.colort{background-color:#58A09E; padding:20px; color:white; font-weight:bold;}
.colorn{background-color:transparent;}
</style>
<body>

<h3>Script has been completed successfully</h3>

<h4>Log file changes:</h4>

<table>
    <tr>
   	    <td class="colort">Changes</td>
    </tr>
"@

$EmailDown = @"
</table>
</body>
"@

if ($Difference -ne ""){
    Foreach ($DifferenceValue in $Difference){
        $DifferenceValueIndicator = $DifferenceValue.SideIndicator
        If ($DifferenceValueIndicator -eq "=>"){
            $NewContentOnly = $DifferenceValue.InputObject
            Add-Content -Path $CheckFile -Value $NewContentOnly
            $EmailTemp = @"
    <tr>
   	    <td>$NewContentOnly</td>
    </tr>
"@
            $EmailResult = $EmailResult + $EmailTemp}}}

$Email = $EmailUp + $EmailResult + $EmailDown

if ($EmailResult -ne ""){

    $EmailParameters = @{
        To = $To
        Subject = "Log File Changed $(Get-Date -format dd/MM/yyyy)"
        Body = $Email
        BodyAsHtml = $True
        Priority = "High"
        UseSsl = $True
        Port = "587"
        SmtpServer = "smtp.office365.com"
        Credential = $EmailCredentials
        From = $From}

    send-mailmessage @EmailParameters
}