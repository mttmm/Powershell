<
$CPUPercent = @{
Name = 'CPUPercent'
Expression = {
$TotalSec = (New-TimeSpan -Start $_.StartTime).TotalSeconds
[Math]::Round( ($_.CPU * 100 / $TotalSec), 2)
}
}


Get-Process -ComputerName $env:computername |
Select-Object -Property Name, CPU, $CPUPercent, Description |
Sort-Object -Property CPUPercent -Descending |
Select-Object -First 5 |format-table -autosize | out-file C:\Temp\top5.log -Append

Write-Output "List top 5 processes end time $(Get-Date)" | out-file C:\Temp\top5.log -Append
>





<#
.Synopsis
   Displays the average CPU consumption on a single vm over a specified number of intervals for the last hour
.EXAMPLE
   Get-CPUStats -Entity rp-vm1 -Interval 5
.EXAMPLE
    Get-CPUStats -Entity rp-vm1 -Interval 15
#>
function Get-CPUStats
{
    [CmdletBinding()]
    [OutputType([int])]
    Param
    (
        [Parameter(Mandatory=$true)]
        [string[]]$Entity,

        # Param2 help description
        [Parameter(Mandatory=$true)]
        [int]$Interval
     )

    Begin
    {
    $CPUStat = @{
    Entity = $Entity
    Stat = 'cpu.usage.average'
    Realtime = $true
}
    }#end Begin
    Process
    {
        Get-Stat @CPUStat | Sort-Object -Property Timestamp,Entity | Group-Object -Property {$_.Entity.Name}, {[System.Math]::Floor($_.Timestamp.Minute/$interval)} | Select-Object -Property @{Name='VM' ;Expression={$_.Name}}, @{Name='TimeStamp' ;Expression={$_.Group[0].TimeStamp}}, @{Name='MemAvg%' ;Expression={[Math]::Round(($_.Group | Measure-Object -Property Value -Average).Average,1)}}
    }#end process
}#close function







  Get-VM | Where {$_.PowerState -eq "PoweredOn"} | Select Name, Host, NumCpu, MemoryMB, `
@{N="CPU Usage (Average), Mhz" ; E={[Math]::Round((($_ | Get-Stat -Stat cpu.usagemhz.average -Start (Get-Date).AddDays(-30) -IntervalMins 5 | Measure-Object Value -Average).Average),2)}}, `
@{N="Memory Usage (Average), %" ; E={[Math]::Round((($_ | Get-Stat -Stat mem.usage.average -Start (Get-Date).AddDays(-30) -IntervalMins 5 | Measure-Object Value -Average).Average),2)}} , `
@{N="Network Usage (Average), KBps" ; E={[Math]::Round((($_ | Get-Stat -Stat net.usage.average -Start (Get-Date).AddDays(-30) -IntervalMins 5 | Measure-Object Value -Average).Average),2)}} , `
@{N="Disk Usage (Average), KBps" ; E={[Math]::Round((($_ | Get-Stat -Stat disk.usage.average -Start (Get-Date).AddDays(-30) -IntervalMins 5 | Measure-Object Value -Average).Average),2)}} |`
Export-Csv -Path d:AverageUsage.csv



Get-VM RP-PS-SQL01 |

select Guest,NumCpu,MemoryMB,Host,UsedSpaceGB,ProvisionedSpaceGB,Name,

    @{N='CPU ratio';E={"$(Get-Stat -Entity $_ -Stat cpu.usage.average -Realtime -MaxSamples 1 | select -ExpandProperty Value) %"}},

    @{N='Memory ratio';E={"{0:P}" -f ($_.ExtensionData.Summary.Quickstats.GuestMemoryUsage/$_.MemoryMB)}} |

Export-Csv -path “C:\Users\gemela\Hardware_info.csv” -NoTypeInformation