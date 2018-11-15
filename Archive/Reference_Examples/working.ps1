#one-liner to get a list of sql servers in a network

#[System.Data.Sql.SqlDataSourceEnumerator]::Instance.GetDataSources()

#get-command | get-random | get-help -ShowWindow


#the new netstat replacement
Get-NetTCPConnection -RemoteAddress (Resolve-DnsName sid-500.com).IPAddress -ErrorAction SilentlyContinue | Format-List
Get-NetTCPConnection -State Established | Format-Table -AutoSize
Get-NetTCPConnection -LocalAddress 172.16.246.110 | Sort-Object LocalPort

# testing connectivity to the default gateway
Test-Connection (Get-NetRoute -DestinationPrefix 0.0.0.0/0 | Select-Object -ExpandProperty Nexthop) -Quiet -Count 1

# messaging all users on a machine or group of machines
(Get-ADComputer -SearchBase "OU=Workstations,DC=sid-500,DC=com" -Filter *).Name | Foreach-Object {Invoke-Command -ComputerName $_ {msg * "Please close all open files. The Server will be shut down in 5 Minutes"}}