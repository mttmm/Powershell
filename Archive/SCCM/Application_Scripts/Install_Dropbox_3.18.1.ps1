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
        ##To Install run .\Install_Dropbox_3.18.1.ps1
        ##Install Dropbox
        

Start-Process -filepath ".\Dropbox_3.18.1.exe" -ArgumentList "/S" -Wait
    }

##Uninstall
ElseIf ($deploymentType -eq 'Uninstall'){
    ###To Uninstall, run .\Install_Dropbox_3.18.1.ps1 Uninstall
    ##Uninstall Dropbox
    Start-Process -filepath "${env:ProgramFiles(x86)}\Dropbox\Client\DropboxUninstaller.exe" -ArgumentList "/S" -Wait
    }

}
Catch {Exit $LASTEXITCODE}
Exit $LASTEXITCODE