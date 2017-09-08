#requires -RunAsAdministrator
function Get-LogonInfo
{
  param
  (
    [Int]$Newest = [Int]::MaxValue,
    [DateTime]$Before,
    [DateTime]$After,
    [string[]]$ComputerName,
    $Authentication = '*',
    $User = '*',
    $Path = '*'
  )

  $null = $PSBoundParameters.Remove('Authentication')
  $null = $PSBoundParameters.Remove('User')
  $null = $PSBoundParameters.Remove('Path')
  $null = $PSBoundParameters.Remove('Newest')
    

  Get-EventLog -LogName Security -InstanceId 4624 @PSBoundParameters |
  ForEach-Object {
    [PSCustomObject]@{
      Time = $_.TimeGenerated
      User = $_.ReplacementStrings[5]
      Domain = $_.ReplacementStrings[6]
      Path = $_.ReplacementStrings[17]
      Authentication = $_.ReplacementStrings[10]

    }
  } |
  Where-Object Path -like $Path |
  Where-Object User -like $User |
  Where-Object Authentication -like $Authentication |
  Select-Object -First $Newest
}
<# $yesterday = (Get-Date).AddDays(-1)
Get-LogonInfo -After $yesterday |
Out-GridView #>


$yesterday = (Get-Date).AddDays(-1)
Get-LogonInfo -After $yesterday -Path *\lsass.exe |
Out-GridView
