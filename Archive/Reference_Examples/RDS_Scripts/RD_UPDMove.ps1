<#USAGE: Move user profile disk to new location based on current and new collection
ACCESS: Account must have admin access on entire RD stack. Including Connection Broker, Gateway, Web Server, Licensing Server, and Session hosts.
ACCESS: Account must have access to UPD file location, ability to read and write
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
        [string]$newCollection,
        
        #If log file is not provided. One will be created at ".\Logs\TempLog.log"
        [Parameter(Mandatory=$False)]
        [Alias("Log")]
        [string]$logFile = ".\TempLog.txt"		
    )

###Declare variables###
$ErrorActionPreference = “SilentlyContinue”

###Declare Functions###

#Write to Log
function AppendLog{
    Param(
        [Parameter(Mandatory=$True)]
        [string]$logEntry
    )
    #If log file exists, write to it
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

#Find user SID based on domain\username then return it
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

#Find active connectino broker and return it
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

    #Write error to log
    Catch{
        AppendLog "$((Get-PSCallStack)[1].Command) -GetActiveCB returned exit code $LASTEXITCODE; Error Details: $($_.ErrorDetails); Error Stack Trace: $($_.ScriptStackTrace); Target Object: $($_.TargetObject); Invocation Info: $($_.InvocationInfo)"
        exit $LASTEXITCODE
    }
}

#Use robocopy to move User Profile Disk based on UPD location in old and new collections
function MoveUserProfileDisk {
    Try{
        #Get active Connection Broker
        $activeCB = GetActiveCB

        #Get oldCollection UPD Info
        $oldCollectionUPDPath = (Get-RDSessionCollectionConfiguration -CollectionName $oldCollection -UserProfileDisk -ConnectionBroker $activeCB).DiskPath

        #Get newCollection UPD Info
        $newCollectionUPDPath = (Get-RDSessionCollectionConfiguration -CollectionName $newCollection -UserProfileDisk -ConnectionBroker $activeCB).DiskPath

        #Get User SID
        $userSID = GetUserSID

        #Determine UPD Name
        $UPDName = "UVHD-" + $userSID + ".vhdx"

        #Robocopy from old location to new location
        robocopy $oldCollectionUPDPath $newCollectionUPDPath $UPDName /copyall /MOV /MT[:8] /R:5 /W:60 /V /TS /FP /Log+:$logFile /np
        AppendLOG "$((Get-PSCallStack)[1].Command) completed successfully, exit code $LASTEXITCODE"
    }

    #Write errors to log and exit
    Catch{
        AppendLog "$((Get-PSCallStack)[1].Command) returned exit code $LASTEXITCODE; Error Details: $($_.ErrorDetails); Error Stack Trace: $($_.ScriptStackTrace); Target Object: $($_.TargetObject); Invocation Info: $($_.InvocationInfo)"
        exit $LASTEXITCODE
    }
}

###Begin commands###
AppendLog "Starting execution of $($PSCmdlet.MyInvocation.MyCommand.Name)"

MoveUserProfileDisk

AppendLog "Completed execution of $($PSCmdlet.MyInvocation.MyCommand.Name)"

exit $LASTEXITCODE