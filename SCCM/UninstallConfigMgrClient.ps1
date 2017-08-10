$servers =  gc "C:\temp\book2.csv"
    foreach ($server in $servers){
        if (Test-Connection $server -Count 1 -ErrorAction SilentlyContinue){
        Try{
            Write-host "$server is online...Removing SCCM Client" -ForegroundColor Green
            Invoke-Command -ComputerName $server -ScriptBlock {Start-Process -Wait -FilePath C:\Windows\ccmsetup\ccmsetup.exe -ArgumentList "/uninstall" -PassThru} -AsJob
            }Catch{
            $_.Exception.Message}
        }
        }
       foreach ($server in $servers){
       
      Test-Path -Path  "\\$server\$env:windir\ccmcache"
       }