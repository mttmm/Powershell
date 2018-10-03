#requires -module ActiveDirectory
# Get-Domainuser.ps1
Function Get-Domainuser {
    [cmdletbinding()]
    Param(
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [ValidateNotNullOrEmpty()]
        [string]$ou,
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string]$domain,
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [ValidateNotNullOrEmpty()]
        [string]$dc,
        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$department
    )
    Begin {
        Write-Verbose "[$((Get-Date).TimeOfDay) BEGIN ] Starting $($myinvocation.mycommand)"
        $properties = "Name", "SamAccountName", "UserPrincipleName", "Description", "Enabled"
        if ($department) {
            $filter = "Department -eq '$department'"
            $properties += "Title", "Department"
        }
        else {
            $filter = "*"
        }
    } #begin
    Process {
        $paramhash = @{
            Searchbase = ""
            Server     = "$($dc).$($domain)"
            Filter     = $filter
        }
        Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] Connecting to domain controller $($dc.toupper())"
        Get-Aduser @paramhash
    }#process
    End {
        "[$((Get-Date).TimeOfDay) END   ] Ending $($myinvocation.MyCommand)"
    }#end

} #close Get-DomainUser

