# Script uses DSC (Desired State Configuration to rename PC, assign network details, promote as DC and make new domain admin user
# DSC; Active Directory; Domain Controller; Networking

<#
REQUIREMENTS: 

Windows PowerShell 5 via Windows Management Framework 5 Production Preview: https://www.microsoft.com/en-us/download/details.aspx?id=48729
DSC Resources: (Install-Module [modulename])
    xActiveDirectory
    xComputer Management
    xNetworking
#>;

# The Local Configuration Manager (LCM) must be configured in advance to know to reboot as soon as one is required
# This cannot be set directly but rather the setting must be saved into a MOF (Management Object Format) plain text configuration file
# This file must then be read by the Set-DSCLocalConfigurationManager Command


#Find-Module -Name xActiveDirectory, xComputerManagement, xNetworking | Install-Module -SkipPublisherCheck -Force

configuration EnableRestarts
{
     LocalConfigurationManager            
        {            
            RebootNodeIfNeeded = $true
        }            
}

# We use the temp file here since we don't actually need to keep this configuration file after execution


EnableRestarts -OutputPath $Env:Temp\ | out-null
Set-DscLocalConfigurationManager -Path $Env:Temp | out-null
Remove-Item C:\Users\ADMINI~1\AppData\Local\Temp\1\localhost.meta.mof -ErrorAction SilentlyContinue

# Request input that is required from the user
do { $ComputerName = Read-Host 'Enter the new Computer Name' } while($ComputerName -eq "")
do { $IPAddress = Read-Host 'Enter the IP address' } while($IPAddress -eq "")
do { $DefGateway = Read-Host 'Enter the default gateway' } while($DefGateway -eq "")

$DomainCreds = Get-Credential -Message "Enter columbusrad.local domain join credentials"
$localCreds = Get-Credential -Message "Enter local administrator credentials"

# Configure all of the settings we want to apply for this configuration
$ConfigData = @{
    AllNodes = @(
        @{
            NodeName = 'localhost'
            MachineName = $ComputerName
            #DomainName = $DomainName
            ADAdminPassword = $DomainCreds.Password
            ADAdminUser = $DomainCreds.UserName
            IPAddress = $IPAddress
            InterfaceAlias = 'Ethernet0'
            DefaultGateway = $DefGateway
            SubnetMask = '24'
            AddressFamily = 'IPv4'
            DNSAddress = '192.168.1.227', '192.168.190.59','192.168.190.151'
            PSDscAllowPlainTextPassword = $true
        }
    )
}

Configuration BaseServerSettings {

    Import-DscResource -Module xActiveDirectory, xComputerManagement, xNetworking, PSDesiredStateConfiguration
 
    Node $AllNodes.NodeName 
    {
        LocalConfigurationManager 
        {
            ActionAfterReboot = 'ContinueConfiguration'            
            ConfigurationMode = 'ApplyOnly'            
            RebootNodeIfNeeded = $true  
        }

        xComputer DomainConfig { 
          Name = $Node.MachineName
          DomainName = "columbusrad.local"
          Credential = $DomainCreds
          JoinOU = 'OU=Servers,OU=Administrative,OU=CRC,DC=ColumbusRad,DC=local'
        }

        xIPAddress SetIP {
            IPAddress = $Node.IPAddress
            InterfaceAlias = $Node.InterfaceAlias
            AddressFamily = $Node.AddressFamily
        }

        xDefaultGatewayAddress SetDefaultGatway {
        Address = $Node.DefaultGateway
        InterfaceAlias = $Node.InterfaceAlias
        AddressFamily = $Node.AddressFamily
            
        }
       
        xDNSServerAddress SetDNS {
            Address = $Node.DNSAddress
            InterfaceAlias = $Node.InterfaceAlias
            AddressFamily = $Node.AddressFamily
        }

        User LocalAdminConfig {
            Ensure = "Present"  
            UserName = "Administrator"
            Password = $localCreds
            DependsOn = "[xComputer]DomainConfig" # Configures xComputer DomainConfig
        }
        
    }
}

# We now need to build a MOF (Managed Object File) based on the configuration defined above and based on the custom configuration parameters we defined
# This will place the MOF in a folder called &quot;BuildTest01&quot; under the current operating folder
BaseServerSettings -ConfigurationData $ConfigData


# We now enforce the configuration using the command syntax below
#Start-DscConfiguration -Wait -Force -Path .\BaseServerSettings -Verbose

