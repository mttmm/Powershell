<#USAGE: Uses username and connection broker to find active sessions for the user and log them off
ACCESS: Account must have access to entire RD stack that connection broker is part of. This inlcudes Connection Broker, Web Server, Gateway, Session Host, Licensing Server
NOTES: Log Files parameter not required. Will create log if not passed as parameter
#>

###Declare Parameters###
Param(
        [Parameter(Mandatory=$True)]
        [string]$userName,

        [Parameter(Mandatory=$True)]
        [string]$connectionBroker,
                
        #If log file is not provided. One will be created at ".\TempLog.log"
        [Parameter(Mandatory=$False)]
        [Alias("Log")]
        [string]$logFile = ".\TempLog.txt"
    )

###Set Variables###
$ErrorActionPreference = “SilentlyContinue”

###Declare Functions###

#Write to log
  function AppendLog{
    Param(
        [Parameter(Mandatory=$True)]
        [string]$logEntry
    )
    #If Log file already exist, write to it
    If (Test-Path -Path $logFile){
        Add-Content -Path $logFile -Value "[$([DateTime]::Now)] $logEntry"
    }

    #If Lof file does not exist, create it and write to it
    Else{
        New-Item -Path $logFile -ItemType File -Force
        Add-Content -Path $logFile -Value "[$([DateTime]::Now)] No existing log file found. Creating log at $logFile"
        Add-Content -Path $logFile -Value "[$([DateTime]::Now)] $logEntry"
    }  
    
}  

#Find and return active Connection Broker
function GetActiveCB{
    Try{
        #Get All DNS Entries for Connection Broker Round Robin setup
        $DNSInfos = Resolve-DnsName -Name $connectionBroker | Select-Object -Property IP4Address -ExpandProperty IP4Address 

        #Determine active Connection Broker from load balanced CB Name
        foreach ($DNSInfo in $DNSInfos){
            $cbName = ([system.net.dns]::GetHostByAddress($DNSInfo)).hostname 
            If((Get-RDConnectionBrokerHighAvailability -ConnectionBroker $cbName).ActiveManagementServer -ne $null){ 
                $activeCB = (Get-RDConnectionBrokerHighAvailability -ConnectionBroker $cbName).ActiveManagementServer             
            }
        }
        #Write successful action to log
                AppendLOG "$((Get-PSCallStack)[1].Command) -GetActiveCB completed successfully for $connectionBroker, exit code $LASTEXITCODE"
                return $activeCB
    }
    #Write error to log and exitm returning error code
    Catch{
        AppendLog "$((Get-PSCallStack)[1].Command) -GetActiveCB returned exit code $LASTEXITCODE; Error Details: $($_.ErrorDetails); Error Stack Trace: $($_.ScriptStackTrace); Target Object: $($_.TargetObject); Invocation Info: $($_.InvocationInfo)"
        exit $LASTEXITCODE
    }
}

#Log off user from all sessions
function LogOffUser{
    Try{
        $activeCB = GetActiveCB
        $userSessions = Get-RDUserSession -ConnectionBroker $activeCB | where-object {$_.UserName -match $userName} -ErrorAction SilentlyContinue

        #Log off user from any active sessions
        foreach ($userSession in $userSessions){ 
            Invoke-RDUserLogoff -HostServer $userSession.HostServer -UnifiedSessionID $userSession.UnifiedSessionID -Force
        }
        #Write successful action to log
        AppendLOG "$((Get-PSCallStack)[1].Command) completed successfully, exit code $LASTEXITCODE"

    }

    #Write error to log and exitm returning error code
    Catch{
        AppendLog "$((Get-PSCallStack)[1].Command) returned exit code $LASTEXITCODE; Error Details: $($_.ErrorDetails); Error Stack Trace: $($_.ScriptStackTrace); Target Object: $($_.TargetObject); Invocation Info: $($_.InvocationInfo)"
        exit $LASTEXITCODE
    }


}


###Start script execution###
AppendLog "Starting execution of $($PSCmdlet.MyInvocation.MyCommand.Name)"

LogOffUser

AppendLog "Completed execution of $($PSCmdlet.MyInvocation.MyCommand.Name)"

exit $LASTEXITCODE