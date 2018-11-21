#Write-Output "List top 5 processes end time $(Get-Date)" | out-file C:\Temp\top5.log -Append
function Get-CPUStats {
    [CmdletBinding()]
    param (

    )

    begin {
    $CPUPercent = @{
    Name='CPUPercent'
    Expression = {$TotalSec = (New-TimeSpan -Start $_.StartTime).TotalSeconds
[Math]::Round( ($_.CPU * 100 / $TotalSec), 2)}
    }
    }#end begin
    process {
    Get-Process | Select-Object -Property Name, CPU, $CPUPercent, Description |Sort-Object -Property CPUPercent -Descending | Select-Object -First 5 |format-table -autosize | out-file C:\Temp\top5.log -Append
    }#end process
}


  Get-Process | Select-Object -Property Name, CPU, Description |Sort-Object -Property CPUPercent -Descending | Select-Object -First 5 |format-table -autosize
Get-Process | Select-Object -Property Name, CPU, Description -First 5 |Sort-Object -Property CPUPercent -Descending |Format-List  | out-file C:\Temp\top5.log -Append
Get-Process | Select-Object -Property Name, CPU, Description -First 5 |Sort-Object -Property CPU -Descending |Format-table -AutoSize
Get-Process |Sort-Object -Property CPUPercent -Descending | Select-Object -Property Name, CPU, Description -First 5 | Format-table -autosize

$CpuCores = (Get-WMIObject Win32_ComputerSystem).NumberOfLogicalProcessors
(Get-Counter "\Process(*)\% Processor Time").CounterSamples | Select InstanceName, @{Name = "CPU %"; Expression = {[Decimal]::Round(($_.CookedValue / $CpuCores), 2)}}


(Get-Counter '\Process(*)\% Processor Time').CounterSamples | Where-Object {$_.CookedValue -gt 5}

(Get-Counter '\Process(*)\% Processor Time').CounterSamples | gm




$Samples = (Get-Counter “\Process($Processname*)\% Processor Time”).CounterSamples
$Samples | Select `
    InstanceName,
@{Name = ”CPU %”; Expression = {[Decimal]::Round(($_.CookedValue / $CpuCores), 2)}}




(Get-WMIObject Win32_ComputerSystem).NumberOfLogicalProcessors
$count = Get-Counter "\Process(*)\"
$count.CounterSamples | Sort-Object CookedValue -Descending | Select-Object InstanceName, CookedValue -First 5





Get-Counter -ListSet * | Sort-Object CounterSetName | Format-Table CounterSetName
(Get-Counter -ListSet Process*).Paths
(Get-Counter -ListSet Processor*).Pathswithinstances
$MemCounters = (Get-Counter -List Memory).Paths
Get-Counter -Counter $MemCounters





P = Get-Counter '\Process(*)\% Processor Time'
$p.CounterSamples | Sort-Object -Property CookedValue -Descending | Format-Table -Auto



$WS = Get-Counter "\Process(*)\Working Set - Private"
$ws.CounterSamples | Sort-Object -Property CookedValue -Descending | Format-Table -Property InstanceName, CookedValue -AutoSize