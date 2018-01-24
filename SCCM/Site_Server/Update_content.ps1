#import the ConfigMgr Module
Import-Module -Name "$(split-path $Env:SMS_ADMIN_UI_PATH)\ConfigurationManager.psd1"

#set the location to the CMSite
$SiteCode = Get-PSDrive -PSProvider CMSITE
Set-location $SiteCode":"

#Create array of all applications
$applicationList = @(Get-CMApplication)




#For each application in array
foreach ($application in $applicationList) {

   #Create array of all deployment types for application
    $deploymentTypeList = @(Get-CMDeploymentType -ApplicationName $application.LocalizedDisplayName -verbose)
    
   #For each deployment type in array
    foreach ($deploymenttype in $deploymentTypeList){

       #Update content on assigned distribution points
        Update-CMDistributionPoint -ApplicationName $application.LocalizedDisplayName -DeploymentTypeName $deploymenttype.LocalizedDisplayName -Verbose

   }
    
   
}