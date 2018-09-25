Function Get-ProvisioningMode {
        $registryPath = 'HKLM:\SOFTWARE\Microsoft\CCM\CcmExec'
        $provisioningMode = (Get-ItemProperty -Path $registryPath).ProvisioningMode

        if ($provisioningMode -eq 'true') {
            $obj = $true
        }
        else {
            $obj = $false
        }
        Write-Output $obj
    }

    Function Get-OSDiskFreeSpace {
        $driveC = Get-WmiObject -Class Win32_LogicalDisk | Where-Object {$_.DeviceID -eq 'C:'} | Select-Object FreeSpace, Size
        $freeSpace = (($driveC.FreeSpace / $driveC.Size) * 100)
        Write-Output ([math]::Round($freeSpace,2))
    }

    Function Get-Computername {
        $obj = (Get-WmiObject Win32_ComputerSystem).Name
        Write-Output $obj
    }

    Function Get-LastBootTime {
        $wmi = Get-WmiObject Win32_OperatingSystem
        $obj = $wmi.ConvertToDateTime($wmi.LastBootUpTime)
        Write-Output $obj
    }

    Function Test-DNSConfiguration {
        Param([Parameter(Mandatory=$true)]$Log)
        $comp = Get-WmiObject Win32_ComputerSystem
        $fqdn = $comp.Name + '.'+$comp.Domain
        $localIPs = Get-WmiObject Win32_NetworkAdapterConfiguration | Where-Object {$_.IPEnabled -Match "True"} |  Select-Object -ExpandProperty IPAddress
        $dnscheck = [System.Net.DNS]::GetHostByName($fqdn)
        $dnsAddressList = $dnscheck.AddressList | Select-Object -ExpandProperty IPAddressToString
        $dnsFail = ''
        $logFail = ''

        Write-Verbose 'Verify that local machines FQDN matches DNS'
        if ($dnscheck.HostName -like $fqdn) {
            $obj = $true
            Write-Verbose 'Checking if one local IP matches on IP from DNS'
            Write-Verbose 'Loop through each IP address published in DNS'
            foreach ($dnsIP in $dnsAddressList) {
                Write-Verbose 'Testing if IP address published in DNS exist in local IP configuration.'
                ##if ($dnsIP -notin $localIPs) { ## Requires PowerShell 3. Works fine :(
                if ($localIPs -notcontains $dnsIP) {
                   $dnsFail += "IP $dnsIP in DNS record do not exist`n"
                   $logFail += "$dnsIP "
                   $obj = $false
                }
            }
        }
        else {
            $dnsFail = 'DNS name: ' +$dnscheck.HostName + ' local fqdn: ' +$fqdn + ' DNS IPs: ' +$dnsAddressList + ' Local IPs: ' + $localIPs
            $obj = $false
        }

        switch ($obj) {
            $false {
                $text = 'DNS Check: FAILED. IP address published in DNS do not match IP address on local machine. Trying to resolve by registerting with DNS server'
                if ($PowerShellVersion -ge 4) {
                    Register-DnsClient | out-null
                }
                else {
                    ipconfig /registerdns | out-null
                }
                Write-Warning $text
                $log.DNS = $logFail
                Out-LogFile -Xml $xml -Text $text
                Out-LogFile -Xml $xml -Text $dnsFail
            }
            $true {
                $text = 'DNS Check: OK'
                Write-Output $text
                $log.DNS = 'OK'
                #Out-LogFile -Xml $xml -Text $text
            }
        }
        #Write-Output $obj
    }

    Function Test-ConfigMgrClient {
        if (Get-Service -Name ccmexec -ErrorAction SilentlyContinue) {
            $text = "Configuration Manager Client is installed"
            Write-Output $text
        }
        else {
            $text = "Configuration Manager client is not installed. Installing and sleeping for 10 minutes for it to configure..."
            Write-Warning $text
            #$newinstall = $true
            Resolve-Client -Xml $xml -ClientInstallProperties $clientInstallProperties -FirstInstall $true
            Start-Sleep 600
        }
        #Out-LogFile -Xml $xml -Text $text
    }

    Function Test-ClientCacheSize {
        $ClientCacheSize = Get-XMLConfigClientCache
        $Cache = Get-WmiObject -Namespace "ROOT\CCM\SoftMgmtAgent" -Class CacheConfig
        $CurrentCache = Get-ClientCache

        if ($ClientCacheSize -match '%') {
            $type = 'percentage'
            # percentage based cache based on disk space
            $num = $ClientCacheSize -replace '%'
            $num = ($num / 100)
            # TotalDiskSpace in Byte
            $TotalDiskSpace = (Get-WmiObject -Class Win32_LogicalDisk | Where-Object {$_.DeviceID -eq 'C:'} | Select-Object -ExpandProperty Size)
            $ClientCacheSize = ([math]::Round(($TotalDiskSpace * $num) / 1048576))
        }
        else {
            $type = 'fixed'
        }

        if ($CurrentCache -eq $ClientCacheSize) {
            $text = "ConfigMgr Client Cache Size: OK"
            Write-Host $text
            $obj = $false
        }

        else {
            switch ($type) {
                'fixed' {$text = "ConfigMgr Client Cache Size: $CurrentCache. Expected: $ClientCacheSize. Redmediating and tagging CcmExec Service for restart..."}
                'percentage' {
                    $percent = Get-XMLConfigClientCache
                    $text = "ConfigMgr Client Cache Size: $CurrentCache. Expected: $ClientCacheSize ($percent). Redmediating and tagging CcmExec Service for restart..."
                }
            }
            
            Write-Warning $text
            $Cache.Size = $ClientCacheSize
            $Cache.Put()
            $obj = $true
        }
        #Out-LogFile -Xml $xml -Text $text
        Write-Output $obj
    }

    Function Test-ClientVersion {
        Param([Parameter(Mandatory=$true)]$Log)
        $ClientVersion = Get-XMLConfigClientVersion
        $installedVersion = Get-ClientVersion
        $log.ClientVersion = $installedVersion

        if ($installedVersion -ge $ClientVersion) {
            $text = 'ConfigMgr Client version is: ' +$installedVersion + ': OK'
            Write-Output $text
            $obj = $false
        }
        elseif ( (Get-XMLConfigClientAutoUpgrade).ToLower() -like 'true' ) {
            $text = 'ConfigMgr Client version is: ' +$installedVersion +': Tagging client for upgrade to version: '+$ClientVersion
            Write-Warning $text
            $obj = $true
        }
        else {
            $text = 'ConfigMgr Client version is: ' +$installedVersion +': Required version: '+$ClientVersion +' AutoUpgrade: false. Skipping upgrade'
            Write-Output $text
            $obj = $false
        }
        #Out-LogFile -Xml $xml -Text $text
        Write-Output $obj
    }

    Function Test-SCCMHardwareInventoryScan {
        Param([Parameter(Mandatory=$true)]$Log)
        $days = Get-XMLConfigHardwareInventoryDays

        $wmi = Get-WmiObject -Namespace root\ccm\invagt -Class InventoryActionStatus | Where-Object {$_.InventoryActionID -eq '{00000000-0000-0000-0000-000000000001}'} | Select-Object @{label='HWSCAN';expression={$_.ConvertToDateTime($_.LastCycleStartedDate)}}
        $HWScanDate = $wmi | Select-Object -ExpandProperty HWSCAN
        $HWScanDate = Get-SmallDateTime $HWScanDate
        $minDate = Get-SmallDateTime((Get-Date).AddDays(-$days))
        if ($HWScanDate -le $minDate) {
            $text = "ConfigMgr Hardware Inventory scan: $HWScanDate. Starting hardware inventory scan of the client."
            Write-Warning $Text
            Get-SCCMPolicyHardwareInventory
            
            # Get the new date after policy trigger
            $wmi = Get-WmiObject -Namespace root\ccm\invagt -Class InventoryActionStatus | Where-Object {$_.InventoryActionID -eq '{00000000-0000-0000-0000-000000000001}'} | Select-Object @{label='HWSCAN';expression={$_.ConvertToDateTime($_.LastCycleStartedDate)}}
            $HWScanDate = $wmi | Select-Object -ExpandProperty HWSCAN
            $HWScanDate = Get-SmallDateTime $HWScanDate            
        }
        else {
            $text = "ConfigMgr Hardware Inventory scan: OK"
            Write-Output $text
        }
        $log.HWInventory = $HWScanDate
    }
     
     
        # SCCM Client evaluation policies
            <# Trigger codes
    {00000000-0000-0000-0000-000000000001} Hardware Inventory
    {00000000-0000-0000-0000-000000000002} Software Inventory 
    {00000000-0000-0000-0000-000000000003} Discovery Inventory 
    {00000000-0000-0000-0000-000000000010} File Collection 
    {00000000-0000-0000-0000-000000000011} IDMIF Collection 
    {00000000-0000-0000-0000-000000000012} Client Machine Authentication 
    {00000000-0000-0000-0000-000000000021} Request Machine Assignments 
    {00000000-0000-0000-0000-000000000022} Evaluate Machine Policies 
    {00000000-0000-0000-0000-000000000023} Refresh Default MP Task 
    {00000000-0000-0000-0000-000000000024} LS (Location Service) Refresh Locations Task 
    {00000000-0000-0000-0000-000000000025} LS (Location Service) Timeout Refresh Task 
    {00000000-0000-0000-0000-000000000026} Policy Agent Request Assignment (User) 
    {00000000-0000-0000-0000-000000000027} Policy Agent Evaluate Assignment (User) 
    {00000000-0000-0000-0000-000000000031} Software Metering Generating Usage Report 
    {00000000-0000-0000-0000-000000000032} Source Update Message
    {00000000-0000-0000-0000-000000000037} Clearing proxy settings cache 
    {00000000-0000-0000-0000-000000000040} Machine Policy Agent Cleanup 
    {00000000-0000-0000-0000-000000000041} User Policy Agent Cleanup
    {00000000-0000-0000-0000-000000000042} Policy Agent Validate Machine Policy / Assignment 
    {00000000-0000-0000-0000-000000000043} Policy Agent Validate User Policy / Assignment 
    {00000000-0000-0000-0000-000000000051} Retrying/Refreshing certificates in AD on MP 
    {00000000-0000-0000-0000-000000000061} Peer DP Status reporting 
    {00000000-0000-0000-0000-000000000062} Peer DP Pending package check schedule 
    {00000000-0000-0000-0000-000000000063} SUM Updates install schedule 
    {00000000-0000-0000-0000-000000000071} NAP action 
    {00000000-0000-0000-0000-000000000101} Hardware Inventory Collection Cycle 
    {00000000-0000-0000-0000-000000000102} Software Inventory Collection Cycle 
    {00000000-0000-0000-0000-000000000103} Discovery Data Collection Cycle 
    {00000000-0000-0000-0000-000000000104} File Collection Cycle 
    {00000000-0000-0000-0000-000000000105} IDMIF Collection Cycle 
    {00000000-0000-0000-0000-000000000106} Software Metering Usage Report Cycle 
    {00000000-0000-0000-0000-000000000107} Windows Installer Source List Update Cycle 
    {00000000-0000-0000-0000-000000000108} Software Updates Assignments Evaluation Cycle 
    {00000000-0000-0000-0000-000000000109} Branch Distribution Point Maintenance Task 
    {00000000-0000-0000-0000-000000000110} DCM policy 
    {00000000-0000-0000-0000-000000000111} Send Unsent State Message 
    {00000000-0000-0000-0000-000000000112} State System policy cache cleanout 
    {00000000-0000-0000-0000-000000000113} Scan by Update Source 
    {00000000-0000-0000-0000-000000000114} Update Store Policy 
    {00000000-0000-0000-0000-000000000115} State system policy bulk send high
    {00000000-0000-0000-0000-000000000116} State system policy bulk send low 
    {00000000-0000-0000-0000-000000000120} AMT Status Check Policy 
    {00000000-0000-0000-0000-000000000121} Application manager policy action 
    {00000000-0000-0000-0000-000000000122} Application manager user policy action
    {00000000-0000-0000-0000-000000000123} Application manager global evaluation action 
    {00000000-0000-0000-0000-000000000131} Power management start summarizer
    {00000000-0000-0000-0000-000000000221} Endpoint deployment reevaluate 
    {00000000-0000-0000-0000-000000000222} Endpoint AM policy reevaluate 
    {00000000-0000-0000-0000-000000000223} External event detection
    #>

    Function Get-SCCMPolicySourceUpdateMessage {
        $trigger = "{00000000-0000-0000-0000-000000000032}"
        Invoke-WmiMethod -Namespace root\ccm -Class sms_client -Name TriggerSchedule $trigger -ErrorAction SilentlyContinue | Out-Null
    }

    Function Get-SCCMPolicySendUnsentStateMessages {
        $trigger = "{00000000-0000-0000-0000-000000000111}"
        Invoke-WmiMethod -Namespace root\ccm -Class sms_client -Name TriggerSchedule $trigger -ErrorAction SilentlyContinue | Out-Null
    }

    Function Get-SCCMPolicyScanUpdateSource {
        $trigger = "{00000000-0000-0000-0000-000000000113}"
        Invoke-WmiMethod -Namespace root\ccm -Class sms_client -Name TriggerSchedule $trigger -ErrorAction SilentlyContinue | Out-Null
    }

    Function Get-SCCMPolicyHardwareInventory {
        $trigger = "{00000000-0000-0000-0000-000000000001}"
        Invoke-WmiMethod -Namespace root\ccm -Class sms_client -Name TriggerSchedule $trigger -ErrorAction SilentlyContinue | Out-Null
    }

    Function Get-SCCMPolicyMachineEvaluation {
        $trigger = "{00000000-0000-0000-0000-000000000022}"
        Invoke-WmiMethod -Namespace root\ccm -Class sms_client -Name TriggerSchedule $trigger -ErrorAction SilentlyContinue | Out-Null
    }
      
       # Gather info about the computer
    Function Get-Info {
        $OS = Get-WmiObject Win32_OperatingSystem
        $ComputerSystem = Get-WmiObject Win32_ComputerSystem

        if ($ComputerSystem.Manufacturer -like 'Lenovo') {
            $Model = (Get-WmiObject Win32_ComputerSystemProduct).Version
        }
        else {
            $Model = $ComputerSystem.Model
        }

        $obj = New-Object PSObject -Property @{
            Hostname = $ComputerSystem.Name;
            Manufacturer = $ComputerSystem.Manufacturer
            Model = $Model
            Operatingsystem = $OS.Caption;
            Architecture = $OS.OSArchitecture;
            Build = $OS.BuildNumber;
            InstallDate = $OS.ConvertToDateTime($OS.InstallDate);
            LastLoggedOnUser = (Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Authentication\LogonUI\').LastLoggedOnUser;
        }

        $obj = $obj
        Write-Output $obj
    }

    Function Get-SmallDateTime {
        Param([Parameter(Mandatory=$false)]$Date)
        if ($null -ne $Date) {
            $obj = ($Date).ToString("yyyy-MM-dd HH:mm:ss")
        }
        else {
            $obj = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
        }
        $obj = $obj -replace '\.', ':'
        Write-Output $obj
    }
