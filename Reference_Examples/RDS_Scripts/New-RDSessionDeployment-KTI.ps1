

# Import the RemoteDesktop module
Import-Module RemoteDesktop

# Create a new RDS Session deployment
New-RDSessionDeployment -ConnectionBroker "KTI01RDCB01.nuvestack.com" -WebAccessServer "KTI01RDWEB01.nuvestack.com" -SessionHost "kti01rdshcol01.nuvestack.com" -Verbose


Write-Verbose "Created new RDS deployment"