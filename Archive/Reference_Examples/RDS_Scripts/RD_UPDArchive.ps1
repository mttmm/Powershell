<#USAGE: Moves UPDs to archive location based on current UPD location from collection and provided archive location
ACCESS: Account must have Full access to Remote Desktop Stack. Including Connection Broker, Web Server, Gateway, Licensing Server, and Session Hosts
ACCESS: Account must have read and write access to current UPD storage location and archive location
NOTES:
#>

###Declare Parameters###
Param(
        [Parameter(Mandatory=$True)]
        [Alias("User")]
        [string]$userName,

        [Parameter(Mandatory=$True)]
        [Alias("CB")]
        [string]$connectionBroker,
		
        [Parameter(Mandatory=$True)]
        [string]$oldCollection,	
		
        [Parameter(Mandatory=$True)]
        [string]$archiveLocation,
        
        #If log file is not provided. One will be created at ".\TempLog.log"
        [Parameter(Mandatory=$False)]
        [Alias("Log")]
        [string]$logFile = ".\TempLog.txt"		
    )

###Declare Variables##
$ErrorActionPreference = “SilentlyContinue”

###Declare Functions###

#Write to log
function AppendLog{
    Param(
        [Parameter(Mandatory=$True)]
        [string]$logEntry
    )
    #If log file already exists, write to it
    If (Test-Path -Path $logFile){
        Add-Content -Path $logFile -Value "[$([DateTime]::Now)] $logEntry"
    }

    #If log file does not exists, create it, then write to it
    Else{
        New-Item -Path $logFile -ItemType File -Force
        Add-Content -Path $logFile -Value "[$([DateTime]::Now)] No existing log file found. Creating log at $logFile"
        Add-Content -Path $logFile -Value "[$([DateTime]::Now)] $logEntry"
    }  
}

#Get user SID based on user name
function GetUserSID{
    Try{
        $objUser = New-Object System.Security.Principal.NTAccount($userName) 
        $strSID = $objUser.Translate([System.Security.Principal.SecurityIdentifier]) 
        $userSID = $strSID.Value

        AppendLOG "$((Get-PSCallStack)[1].Command) -GetUserSID completed successfully for $userName, exit code $LASTEXITCODE"
        return $userSID
    }

    Catch{
        AppendLog "$((Get-PSCallStack)[1].Command) -GetUserSID returned exit code $LASTEXITCODE; Error Details: $($_.ErrorDetails); Error Stack Trace: $($_.ScriptStackTrace); Target Object: $($_.TargetObject); Invocation Info: $($_.InvocationInfo)"
        exit $LASTEXITCODE
    }

}

#Get active connection broker based on connection broker DNS name
function GetActiveCB{
    Try{
        #Get All DNS Entries for Connection Broker Round Robin setup
        $DNSInfos = Resolve-DnsName -Name $connectionBroker | Select-Object -Property IP4Address -ExpandProperty IP4Address 

        #Determine active Connection Broker from load balanced CB Name
        foreach ($DNSInfo in $DNSInfos){
            If((Get-RDConnectionBrokerHighAvailability -ConnectionBroker $DNSInfo).ActiveManagementServer -ne $null) 
                {$activeCB = ([system.net.dns]::GetHostByAddress($DNSInfo)).hostname} 
            }

        AppendLOG "$((Get-PSCallStack)[1].Command) -GetActiveCB completed successfully for $connectionBroker, exit code $LASTEXITCODE"
        return $activeCB
    }

    Catch{
        AppendLog "$((Get-PSCallStack)[1].Command) -GetActiveCB returned exit code $LASTEXITCODE; Error Details: $($_.ErrorDetails); Error Stack Trace: $($_.ScriptStackTrace); Target Object: $($_.TargetObject); Invocation Info: $($_.InvocationInfo)"
        exit $LASTEXITCODE
    }
}

#Move user profile disk
function MoveUserProfileDisk {
    Try{
        #Get active Connection Broker
        $activeCB = GetActiveCB

        #Get oldCollection UPD Info
        $oldCollectionUPDPath = (Get-RDSessionCollectionConfiguration -CollectionName $oldCollection -UserProfileDisk -ConnectionBroker $activeCB).DiskPath

        #Get User SID
        $userSID = GetUserSID

        #Determine UPD Name
        $UPDName = "UVHD-" + $userSID + ".vhdx"

        #Robocopy from old location to new location

        robocopy $oldCollectionUPDPath $archiveLocation $UPDName /copyall /MOV /MT[:8] /MINLAD:30 /R:5 /W:60 /V /TS /FP /Log+:$logFile /np
        AppendLOG "$((Get-PSCallStack)[1].Command) completed successfully, exit code $LASTEXITCODE"
    }

    Catch{
        AppendLog "$((Get-PSCallStack)[1].Command) returned exit code $LASTEXITCODE; Error Details: $($_.ErrorDetails); Error Stack Trace: $($_.ScriptStackTrace); Target Object: $($_.TargetObject); Invocation Info: $($_.InvocationInfo)"
        exit $LASTEXITCODE
    }
}

###Start script actions###
AppendLog "Starting execution of $($PSCmdlet.MyInvocation.MyCommand.Name)"

MoveUserProfileDisk

AppendLog "Completed execution of $($PSCmdlet.MyInvocation.MyCommand.Name)"

exit $LASTEXITCODE