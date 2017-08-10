##Declare parameters
Param (
	[Parameter(Mandatory=$false)]
	[ValidateSet('Install','Uninstall')]
	[string]$DeploymentType = 'Install'
)



##Script Body
Try{
    ##Install
    If ($deploymentType -ine 'Uninstall'){
        ##To Install Filezille run .\Filezilla_Install.ps1
        #Uninstall Older Versions first
$uninstallExe86 = "${env:ProgramFiles(x86)}\FileZilla FTP Client\uninstall.exe"
$uninstallExe64 = "${env:ProgramFiles}\FileZilla FTP Client\uninstall.exe"
        If (Test-Path "${env:ProgramFiles(x86)}\FileZilla FTP Client\uninstall.exe")
             {
             &$uninstallExe86 /S
             }
        ElseIf (Test-Path "${env:ProgramFiles}\FileZilla FTP Client\uninstall.exe")
            {
            &$uninstallExe64 /S
            }

Start-Process -filepath ".\FileZilla_3.16.1_win32-setup.exe" -ArgumentList "/S" -Wait

        Copy-Item .\fzdefaults.xml -Destination "${env:ProgramFiles(x86)}\FileZilla FTP Client" -Recurse -Force
    }

##Uninstall
ElseIf ($deploymentType -eq 'Uninstall'){
    ###To Uninstall, run .\Filezille_Install.ps1 Uninstall
    #Uninstall FileZilla
    Start-Process -filepath "${env:ProgramFiles(x86)}\FileZilla FTP Client\uninstall.exe" -ArgumentList "/S" -Wait
    Remove-Item "${env:ProgramFiles(x86)}\FileZilla FTP Client\fzdefaults.xml" -Recurse -Force
    }

}
Catch {Exit $LASTEXITCODE}
Exit $LASTEXITCODE