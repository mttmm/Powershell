function Add-AcmeComputer {
    param(
        [string[]]$ComputerName,
        [string]$Domain,
        [switch]$Wait
    )
 
    foreach ($computer in $ComputerName) {
        if (-not (Test-Connection -ComputerName $computer -Quiet -Count 1)) {
            Write-Warning "Could not ping computer [$computer]"
        } else {
            Write-Information "[$computer] is being added to domain [$Domain]..."
            Add-Computer -ComputerName $computer -Domain $Domain -Restart
            if ($Wait.IsPresent) {
                ## Give it some time to go offline
                while (Test-Connection -ComputerName $computer -Quiet -Count 1) {
                    Start-Sleep -Seconds 2
                }
 
                ## It's now offline, wait for it to come back
                while (-not (Test-Connection -ComputerName $computer -Quiet -Count 1)) {
                    Start-Sleep -Seconds 2
                    Write-Information "[$computer] rebooted and is back!"
                }
            }
            Write-Information "[$computer] was added to domain [$Domain]..."
        }
    }
}