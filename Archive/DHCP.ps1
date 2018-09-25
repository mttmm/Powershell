#turn this into a function
#get-credential for dhcp service account to pass through variable
$DhcpServer = "DC01.mttmmtech.com"
$ServerIP = "192.168.5.2"
$startrange = "192.168.5.100"
$endrange = "192.168.5.199"
$ScopeName = "Corp"
$mask = "255.255.255.0"
$state = "active"
$domain = "mttmmtech.com"
$router = "192.168.5.1"
Add-DhcpServerInDC -DnsName $DhcpServer -IPAddress $ServerIP
Add-DhcpServerSecurityGroup -ComputerName $DhcpServer
#Service Account needs to be created prior to this
Set-DhcpServerDnsCredential -ComputerName $DhcpServer
Add-DhcpServerv4Scope -EndRange $endrange -Name $ScopeName -StartRange $startrange -SubnetMask $mask -State $state
Set-DhcpServerv4OptionValue -ComputerName $DhcpServer -DnsServer $ServerIP -DnsDomain $domain -Router $router
#list option values
#Get-DhcpServerv4OptionValue | fl
#Get-DhcpServerv4Scope
