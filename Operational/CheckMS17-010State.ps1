[reflection.assembly]::LoadWithPartialName("System.Version")
$os = Get-WmiObject -class Win32_OperatingSystem
$osName = $os.Caption
$s = "%systemroot%\system32\drivers\srv.sys"
$v = [System.Environment]::ExpandEnvironmentVariables($s)
If (Test-Path "$v")
    {
    Try
        {
        $versionInfo = (Get-Item $v).VersionInfo
        $versionString = "$($versionInfo.FileMajorPart).$($versionInfo.FileMinorPart).$($versionInfo.FileBuildPart).$($versionInfo.FilePrivatePart)"
        $fileVersion = New-Object System.Version($versionString)
        }
    Catch
        {
        $state = $null
        Return $state
        }
    }
Else
    {
    $state = $null
    Return $state
    }
if ($osName.Contains("Vista") -or ($osName.Contains("2008") -and -not $osName.Contains("R2")))
    {
    if (([string]($version[3]))[0] -eq "1")
        {
        $currentOS = "$osName GDR"
        $expectedVersion = New-Object System.Version("6.0.6002.19743")
        } 
    elseif (([string]($version[3]))[0] -eq "2")
        {
        $currentOS = "$osName LDR"
        $expectedVersion = New-Object System.Version("6.0.6002.24067")
        }
    else
        {
        $currentOS = "$osName"
        $expectedVersion = New-Object System.Version("9.9.9999.99999")
        }
    }
elseif ($osName.Contains("Windows 7") -or ($osName.Contains("2008 R2")))
    {
    $currentOS = "$osName LDR"
    $expectedVersion = New-Object System.Version("6.1.7601.23689")
    }
elseif ($osName.Contains("Windows 8.1") -or $osName.Contains("2012 R2"))
    {
    $currentOS = "$osName LDR"
    $expectedVersion = New-Object System.Version("6.3.9600.18604")
    }
elseif ($osName.Contains("Windows 8") -or $osName.Contains("2012"))
    {
    $currentOS = "$osName LDR"
    $expectedVersion = New-Object System.Version("6.2.9200.22099")
    }
elseif ($osName.Contains("Windows 10"))
    {
    if ($os.BuildNumber -eq "10240")
        {
        $currentOS = "$osName TH1"
        $expectedVersion = New-Object System.Version("10.0.10240.17319")
        }
    elseif ($os.BuildNumber -eq "10586")
        {
        $currentOS = "$osName TH2"
        $expectedVersion = New-Object System.Version("10.0.10586.839")
        }
    elseif ($os.BuildNumber -eq "14393")
        {
        $currentOS = "$($osName) RS1"
        $expectedVersion = New-Object System.Version("10.0.14393.953")
        }
    elseif ($os.BuildNumber -eq "15063")
        {
        $currentOS = "$osName RS2"
        #"No need to Patch. RS2 is released as patched. "
        $state = "Patched"
        return $state
        }
    }
elseif ($osName.Contains("2016"))
    {
    $currentOS = "$osName"
    $expectedVersion = New-Object System.Version("10.0.14393.953")
    }
elseif ($osName.Contains("Windows XP"))
    {
    $currentOS = "$osName"
    $expectedVersion = New-Object System.Version("5.1.2600.7208")
    }
elseif ($osName.Contains("Server 2003"))
    {
    $currentOS = "$osName"
    $expectedVersion = New-Object System.Version("5.2.3790.6021")
    }
else
    {
    $currentOS = "$osName"
    $expectedVersion = New-Object System.Version("9.9.9999.99999")
    }
If ($($fileVersion.CompareTo($expectedVersion)) -lt 0)
    {
    $state = "NotPatched - $versionString"
    }
Else
    {
    $state = "Patched"
    }
$state