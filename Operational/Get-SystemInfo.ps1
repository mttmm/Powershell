function Get-SystemInfo {
param
(
[parameter(HelpMessage='Enter the following values: LocalHost, ServerOnly, DCOnly, ClientOnly or AllComputer')]
[ValidateSet('LocalHost', 'ServerOnly', 'DCOnly', 'ClientOnly', 'AllComputer')]
$Scope, $ComputerName
)
$header='Host Name','OS','Version','Manufacturer','Configuration','Build Type','Registered Owner','Registered Organization','Product ID','Install Date','Boot Time','System Manufacturer','Model','Type','Processor','Bios','Windows Directory','System Directory','Boot Device','Language','Keyboard','Time Zone','Total Physical Memory','Available Physical Memory','Virtual Memory','Virtual Memory Available','Virtual Memory in Use','Page File','Domain','Logon Server','Hotfix','Network Card','Hyper-V'
switch ($Scope)
{
'ServerOnly' {Invoke-Command -ComputerName (Get-ADComputer -Filter {operatingsystem -like '*server*'}).Name {systeminfo /FO CSV | Select-Object -Skip 1} -ErrorAction SilentlyContinue | ConvertFrom-Csv -Header $header | Out-GridView}
'DCOnly' {Invoke-Command -ComputerName (Get-ADDomainController -Filter *).Name {systeminfo /FO CSV | Select-Object -Skip 1} -ErrorAction SilentlyContinue | ConvertFrom-Csv -Header $header | Out-GridView}
'LocalHost' {systeminfo /FO CSV | Select-Object -Skip 1 | ConvertFrom-Csv -Header $header | Out-GridView}
'ClientOnly' {Invoke-Command -ComputerName (Get-ADComputer -Filter {operatingsystem -notlike '*server*'}).Name {systeminfo /FO CSV | Select-Object -Skip 1} -ErrorAction SilentlyContinue | ConvertFrom-Csv -Header $header | Out-GridView}
'AllComputer' {Invoke-Command -ComputerName (Get-ADComputer -Filter *).Name {systeminfo /FO CSV | Select-Object -Skip 1} -ErrorAction SilentlyContinue | ConvertFrom-Csv -Header $header | Out-GridView}
}
If ($ComputerName) {
Invoke-Command -ComputerName $ComputerName {systeminfo /FO CSV | Select-Object -Skip 1} -ErrorAction SilentlyContinue | ConvertFrom-Csv -Header $header | Out-GridView
}
}