function New-VirtualMachine
{
	[CmdletBinding(DefaultParameterSetName = 'None')]
	param
	(
		[Parameter(Mandatory, ParameterSetName = 'ByName')]
		[ValidateCount(1, 5)]
		[string[]]$Name,
		
		[Parameter(Mandatory, ParameterSetName = 'ById')]
		[ValidateNotNullOrEmpty()]
		[string]$Id,
		
		[Parameter()]
		[ValidateNotNullOrEmpty()]
		[ValidateRange(1, 5)]
		[int]$Count = 1,
		
		[Parameter()]
		[ValidateNotNull()]
		[ValidateRange(512MB, 1024MB)]
		[int]$MemoryStartupBytes,
		
		[Parameter()]
		[ValidateNotNullOrEmpty()]
		[ValidateSet('1', '2')]
		[int]$Generation = 2,
		
		[Parameter()]
		[ValidateScript({ Test-Path -Path $_ -PathType Container })]
		[ValidatePattern('^C:\\')]
		[string]$Path = 'C:\somebogusfolder',
		
		[Parameter()]
		[AllowNull()]
		[string]$OperatingSystem
	)
	
	if ($PSCmdlet.ParameterSetName -eq 'ById')
	{
		Write-Host "You're using the ById parameter set by using the Id parameter [$($Id)]"
	}
	elseif ($PSCmdlet.ParameterSetName -eq 'ByName')
	{
		Write-Host "You're using the ByName parameter set by using the Name parameter [$($Name)]"	
	}

    Write-host $count
}

#region Parameter sets with mandatory parameters
New-VirtualMachine -Name 'MYNEWVM'
New-VirtualMachine -Id 'HYPERVHOST1'
#endregion

#region Parameter sets with optional params (Default)

New-VirtualMachine ## will not work

## Add a default parameter set 
New-VirtualMachine -Count 2

#endregion

#region in help
help New-VirtualMachine

help Test-Connection
#endregion

#region Using Get-Command
## Add default parameter set
$command = Get-Command New-VirtualMachine
$command.DefaultParameterSet
$command.ParameterSets | Select name

## Find params inside of parameter sets
($command.ParameterSets[2]).Parameters | ft name
#endregion