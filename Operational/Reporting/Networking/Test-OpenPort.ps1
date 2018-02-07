function Test-OpenPort {
 
    <# 
 
.SYNOPSIS
Test-OpenPort is an advanced Powershell function. Test-OpenPort acts like a port scanner. 
 
.DESCRIPTION
Uses Test-NetConnection. Define multiple targets and multiple ports. 
 
.PARAMETER
Target
Define the target by hostname or IP-Address. Separate them by comma. Default: localhost 
 
.PARAMETER
Port
Mandatory. Define the TCP port. Separate them by comma. 
 
.EXAMPLE
Test-OpenPort -Target sid-500.com,cnn.com,10.0.0.1 -Port 80,443 
 
.NOTES
Author: Patrick Gruenauer
Web:
https://sid-500.com 
 
.LINK
None. 
 
.INPUTS
None. 
 
.OUTPUTS
None.
 
#>
 
    [CmdletBinding()]
 
    param
 
    (
 
        [Parameter(Position = 0)]
        $Target = 'localhost',
 
        [Parameter(Mandatory = $true, Position = 1, Helpmessage = 'Enter Port Numbers. Separate them by comma.')]
        $Port
 
    )
 
    $result = @()
 
    foreach ($t in $Target)
    {
 
        foreach ($p in $Port)
        {
 
            $a = Test-NetConnection -ComputerName $t -Port $p -WarningAction SilentlyContinue
 
            $result += New-Object -TypeName PSObject -Property ([ordered]@{
                    'Target'        = $a.ComputerName;
                    'RemoteAddress' = $a.RemoteAddress;
                    'Port'          = $a.RemotePort;
                    'Status'        = $a.tcpTestSucceeded
 
                })
 
        }
 
    }
 
    Write-Output $result
 
}