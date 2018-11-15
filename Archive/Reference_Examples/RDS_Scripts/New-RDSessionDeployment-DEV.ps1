

# Import the RemoteDesktop module
Import-Module RemoteDesktop

# Create a new RDS Session deployment
New-RDSessionDeployment -ConnectionBroker "DEV04RDCB01.nuvestack.com" -WebAccessServer "DEV04RDWEB01.nuvestack.com" -SessionHost @("DEV04RDSHCOL01.nuvestack.com","DEV05RDSHCOL02.nuvestack.com","DEV04RDSHCOL03.nuvestack.com","DEV05RDSHCOL04.nuvestack.com") -Verbose


Write-Verbose "Created new RDS deployment"