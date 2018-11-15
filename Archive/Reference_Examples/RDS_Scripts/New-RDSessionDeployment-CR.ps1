

# Import the RemoteDesktop module
Import-Module RemoteDesktop

# Create a new RDS Session deployment
New-RDSessionDeployment -ConnectionBroker "CR02rdcb02.nuvestack.com" -WebAccessServer "cr02rdweb02.nuvestack.com" -SessionHost @("CR01RDSHCR01.NUVETACK.COM","cr02rdshcr02.nuvestack.com") -Verbose


Write-Verbose "Created new RDS deployment"