$computers = 
@"
drctfsbldp01
  odrc-vodata1
  vodportal2
   drc-lex-scan-01
   drc-rici-fp-1
   drc-rici-fp-2
   odrc_ncci_1
   odrc_rici_2
   odrceformdev01
   co-lausche-01
   co-lebanon-01
   co-lima-01
   co-ports-01
   dpcsinf-01
   drcpdc-01
   odrc_tci_1
   odrc_toci_1
   Odrc-laeci-2
   odrc_dci_1
   oras40
   osp-imtsrv

"@
$compsarray = @()
$Computers.Split("`n") | % { if ($_.Trim()) { $CompsArray += $_.Trim()  } }

foreach($machine in $compsarray){

if (Test-Connection $machine -Count 1 -ErrorAction SilentlyContinue){
try{
    Write-Host "$machine is up.  Stopping CcmExec service..." -ForegroundColor Green
    Invoke-Command -ComputerName $machine -ScriptBlock {Stop-Process -Name CcmExec -Force -PassThru } 
}catch{$error}
}
}
foreach($machine in $compsarray){get-service -ComputerName $machine -Name CcmExec -ErrorAction SilentlyContinue}