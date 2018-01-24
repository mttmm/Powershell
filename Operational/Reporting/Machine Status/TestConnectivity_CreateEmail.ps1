$Servers = (Get-Content C:\DP.txt)
$offline = @()
Foreach($machine in $servers){
if (Test-Connection -ComputerName $machine -Count 1 -Quiet -ErrorAction Continue){
Write-Host "$machine is online" -ForegroundColor Green
}else{
Write-Host "$machine is offline" -ForegroundColor Magenta
$offline +=$machine
}
}
$msgBoxInput =  [System.Windows.MessageBox]::Show("Ping Test Completed.  Offline Machines: $offline 
Would you like to send an email to the institutions?",'Connectivity Check','YesNoCancel','Error')

  switch  ($msgBoxInput) {

  'Yes' {
 $ol = New-Object -comObject Outlook.Application
$mail = $ol.CreateItem(0)
$mail.Subject = "Distribution Point Offline"
$mail.Body = "The following SCCM distribution point servers have not responded to a ping request: 
$offline  
Please check to see if the server is offline."
$mail.save()

$inspector = $mail.GetInspector
$inspector.Display()
  

  }

  'No' {

  ## Do something

  }

  'Cancel' {

  ## Do something

  }

  }




#$wshell = New-Object -ComObject Wscript.Shell
#$wshell.Popup("Operation Completed",0,"Done",0x1)

