$timestamp = Get-Date -format "yyyyMMdd-HH.mm"
# $csvFile = Read-Host "Enter csv file"
$csvfile = "C:\temp\$timestamp-rdmvms.csv"
 
$report = @()
$vms = Get-VM | Get-View
foreach($vm in $vms){
   foreach($dev in $vm.Config.Hardware.Device){   
      if(($dev.gettype()).Name -eq "VirtualDisk"){
         if(($dev.Backing.CompatibilityMode -eq "physicalMode") -or ($dev.Backing.CompatibilityMode -eq "virtualMode")){
         #if($dev.Backing.CompatibilityMode -eq "physicalMode"){
		 $row = "" | select VMName, Host, HDDeviceName, HDFileName, Mode
		 $row.VMName = $vm.Name
		 $getvm = Get-VM $row.VMName
		 $row.Host = $getvm.VMHost
		 $row.HDDeviceName = $dev.Backing.DeviceName
		 $row.HDFileName = $dev.Backing.FileName
		 $row.Mode = $dev.Backing.CompatibilityMode
		 $report += $row
		 }   
	  } 
   }
}
$report | export-csv -NoTypeInformation $csvfile