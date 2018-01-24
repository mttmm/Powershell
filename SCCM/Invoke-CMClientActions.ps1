Function Invoke-CMClient{

    PARAM(
            [Parameter(Mandatory=$True,ValueFromPipeline=$True,ValueFromPipelineByPropertyName=$True)]
            [string[]]$ComputerName = $env:COMPUTERNAME,

            [Parameter(Mandatory=$True)]
            [ValidateSet('HardwareInv','SoftwareInv','UpdateScan','MachinePol','UserPolicy','DiscoveryInv','FileCollect')]
            [string]$Action

            )#Close Param

    #$Action...actions...actions...
    SWITCH ($action) {
                        'HardwareInv'  {$_action = "{00000000-0000-0000-0000-000000000001}"}
                        'SoftwareInv'  {$_action = "{00000000-0000-0000-0000-000000000002}"}
                        'UpdateScan'   {$_action = "{00000000-0000-0000-0000-000000000113}"}
                        'MachinePol'   {$_action = "{00000000-0000-0000-0000-000000000021}"}
                        'UserPolicy'   {$_action = "{00000000-0000-0000-0000-000000000027}"}
                        'FileCollect'  {$_action = "{00000000-0000-0000-0000-000000000010}"}
                        'DiscoveryInv' {$_action = "{00000000-0000-0000-0000-000000000003}"}
                        } 
                        #switch
FOREACH ($Computer in $ComputerName){
        if ($PSCmdlet.ShouldProcess("$action $computer")) {
                    
            Invoke-WmiMethod -ComputerName $Computer -Namespace root\CCM -Class SMS_Client -Name TriggerSchedule -ArgumentList "$_action"
                                        
        }#if
    }#End FOREACH Statement
   
            
}#Close Function Invoke-CMClient