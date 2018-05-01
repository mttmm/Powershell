Connect-VIServer MYVISERVER
 
$VMhosts = Get-VMHost | Get-View
Foreach ($vmhost in $vmhosts){
   Write-Output $vmhost.Name
   $pnic = 0
   Do {    
      $Speed = $VMhost.Config.Network.Pnic[$pnic].LinkSpeed.SpeedMb    
      Write "Pnic$pnic $Speed"   
      $pnic ++
   } Until ($pnic -eq ($VMhost.Config.Network.Pnic.Length))}







   Get-VM | Where {$_.PowerState -eq "PoweredOn"} | 
Select Name, Host, NumCpu, MemoryMB,
 @{N=Cpu.UsageMhz.Average;E={[Math]::Round((($_ |Get-Stat -Stat cpu.usagemhz.average -Start (Get-Date).AddHours(-24)-IntervalMins 5 -MaxSamples (12) |Measure-Object Value -Average).Average),2)}},
 @{N=Mem.Usage.Average;E={[Math]::Round((($_ |Get-Stat -Stat mem.usage.average -Start (Get-Date).AddHours(-24)-IntervalMins 5 -MaxSamples (12) |Measure-Object Value -Average).Average),2)}} `
 | Export-Csv c:\Temp\stats.csv


 Get-VMHost | Select @{N=“Cluster“;E={Get-Cluster -VMHost $_}}, Name, @{N=“NumVM“;E={($_ | Get-VM).Count}} | Sort Cluster, Name | Export-Csv -NoTypeInformation c:\temp\clu-host-numvm.csv

