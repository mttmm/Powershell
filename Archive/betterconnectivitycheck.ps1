# this uses a Here-String so you can copy/paste machine names inside the quotes and not worry about formatting.  You could also Get-Content on this to populate the array
Function ConnectivityTest{
$computers =
@"
DPCS-DC-01
PROBELAUS
EZRA
HEATDB
DPCSALUMSQL
DPCSNAS-OLD
DPCSHELP08
CO-CINCY-02
COTECH03
DPCSALUMBACKUP
DPCSHEAT
OSC-BW-KP
LEISTERTECHLAP
CO7PERS15
MOSES
OSP
FEEPORTAL
PAROLEREC
DPCSINF
COTECHTAB05
CCISWEB
SYNCSERVER
COLAP07
DPCSNAS
PROBECINCY
DPCS_CENTRALOLD
LEADS-CO-01
ITSQL964
DPCSASHCO01
DPCSINF-01
DPCS-DC-02
DPCSPDC-01
"@
$computerarray = @()
$Computers.Split("`n") | % { if ($_.Trim()) { $ComputerArray += $_.Trim()  } }
  
  foreach($comp in $computerarray){
   if( Test-Connection $comp -Quiet -Count 1 -ErrorAction SilentlyContinue) {
   Write-Host "$comp is up"  -ForegroundColor Green
   }
   Else {
   Write-Host "Cannot Ping $comp" -ForegroundColor Red
   }
  
    if (Test-Path -Path \\$comp\c$\windows\ccmcache -ErrorAction SilentlyContinue){
    Write-Host "SCCM Installed on $comp." -ForegroundColor Green
    Invoke-Command -ComputerName $comp -ScriptBlock {get-wmiobject -query "SELECT * FROM CCM_InstalledComponent" -namespace "ROOT\ccm" | where { $_.Name -eq "CcmFramework" -and $_.Version -eq "5.00.8239.1301"}}
    }
    Else{
    Write-host "SCCM NOT Installed on $comp" -ForegroundColor Red
    }
   
    if (Test-WSMan $comp -ErrorAction SilentlyContinue){
    Write-Host "WINRM is Enabled on $comp" -ForegroundColor Green
    }
    Else{
    Write-Host "WINRM is NOT Enabled on $comp" -ForegroundColor Red

    }
    Get-ADComputer $comp  | Select-Object Name,Enabled,distinguishedname | ft
}}


connectivitytest | export-csv c:\temp\out.csv