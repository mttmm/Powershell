$NatNicIP = '10.10.10.1'
$NatNicSubnet = '10.10.10.0'
$NatNicPrefixLength = '24'
$NatName = 'Nat-Network'

New-VMSwitch -Name $NatName -SwitchType Internal

# Get the MAC Address of the VM Adapter bound to the virtual switch
$MacAddress = (Get-VMNetworkAdapter -ManagementOS -SwitchName Nat-Network).MacAddress

# Use the MAC Address of the Virtual Adapter to look up the Adapter in the Net Adapter list
$Adapter = Get-NetAdapter | Where-Object { (($_.MacAddress -replace '-','') -eq $MacAddress) }

New-NetIPAddress –IPAddress $NatNicIP -PrefixLength $NatNicPrefixLength -InterfaceIndex $Adapter.ifIndex

New-NetNat –Name $('Item-' + $NatName) –InternalIPInterfaceAddressPrefix $($NatNicSubnet+ '/' + $NatNicPrefixLength)