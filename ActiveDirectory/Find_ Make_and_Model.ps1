$hash = Import-Csv "\\codata\SCCM-Documentation\SCCM Technical Documentation\Reports\1.12.17_Manufacturer_Model.csv"
$hash | Group-Object {$_.Manufacturer} -NoElement | Select-Object Name,Count | out-file C:\temp\machines.txt
$hash | Group-Object {$_.Model} -NoElement | Select-Object Name,Count | out-file C:\temp\machines.txt -Append
C:\temp\machines.txt