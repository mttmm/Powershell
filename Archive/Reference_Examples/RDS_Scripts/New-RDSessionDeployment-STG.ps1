

# Import the RemoteDesktop module
Import-Module RemoteDesktop

# Create a new RDS Session deployment
New-RDSessionDeployment -ConnectionBroker "stg04rdcb01.nuvestack.com" -WebAccessServer "stg04RDWEB01.nuvestack.com" -SessionHost @("STG04RDSHCOL01.nuvestack.com","STG05RDSHCOL02.nuvestack.com","STG04RDSHCOL03.nuvestack.com","STG05RDSHCOL04.nuvestack.com") -Verbose


Write-Verbose "Created new RDS deployment"