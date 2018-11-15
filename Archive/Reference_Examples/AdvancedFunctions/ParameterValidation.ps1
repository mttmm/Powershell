function New-VirtualMachine
{
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory)]
		[ValidateCount(1, 5)]
		[string[]]$Name,
		
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
		[ValidateScript({
	        if (-not (Test-Path -Path $_ -PathType Container))
	        {
		        throw "The folder [$_] does not exist. Try another"
	        }
	        else
	        {
		        $true
            }
        })]
		[ValidatePattern('^C:\\')]
		[string]$Path = 'C:\somebogusfolder',
	
		[Parameter()]
		[AllowNull()]
		[string]$OperatingSystem,

		[Parameter(Mandatory)]
		[AllowNull()]
		[string]$AllowNullParam
	)
}

#region ValidateScript
New-VirtualMachine -Name 'MYNEWVM' -Path 'C:\somebogusfolder' ## fails if detects exception, $true otherwise

#region Make the output prettier

#[ValidateScript({
#	if (-not (Test-Path -Path $_ -PathType Container))
#	{
#		throw "The folder [$_] does not exist. Try another"
#	}
#	else
#	{
#		$true
#	}
#})]

#endregion

#region Other ValidateScript examples
#[ValidateScript({
#	if (Test-Connection -ComputerName $_ -Quiet -Count 1)
#	{
#		throw "The computer [$_] is offline. Try another"
#	}
#	else
#	{
#		$true
#	}
#})]
#endregion

#endregion

#region ValidatePattern
New-VirtualMachine -Name 'MYNEWVM' -Path 'Z:\'
'C:\somefolder' -match '^C:\\'
#endregion

#region ValidateSet
New-VirtualMachine -Name 'MYNEWVM' -Generation

help New-VirtualMachine
#endregion

#region ValidateRange
New-VirtualMachine -Name 'MYNEWVM' -MemoryStartupBytes 128MB
New-VirtualMachine -Name 'MYNEWVM' -Count 10
#endregion

#region ValidateCount
New-VirtualMachine -Name 'MYNEWVM','MYOTHERVM'
#endregion

#region Null attributes
New-VirtualMachine -Name 'MYNEWVM' -NullParamTest $null
New-VirtualMachine -Name 'MYNEWVM' -NullParamTest ''
## Change param to [ValidateNotNull]
New-VirtualMachine -Name 'MYNEWVM' -NullParamTest ''

New-VirtualMachine -Name 'MYNEWVM' -AllowNullParam '' ## Only applies to mandatory parameters
#endregion