$mammo = Get-WmiObject -Class Win32_useraccount -Filter 'Name = "mammotech"' | Select-Object name, passwordchangeable, passwordexpires
 if(!$mammo){$compliance = "No User Exists"}
    elseif (($mammo.passwordchangeable -eq $False) -and ($mammo.passwordexpires -eq $False)){
            $compliance = "Compliant"
        }else {
                $compliance= "Noncompliant"}
                Return $compliance






                try{
                Get-WmiObject -Class Win32_useraccount -Filter 'Name = "m11ammotech"' | Set-WmiInstance -Arguments @{passwordchangeable=$false} -Verbose
                }catch{
                     Write-Error "$($_.Exception.Message) - Line Number: $($_.InvocationInfo.ScriptLineNumber)"
                }
                Get-WmiObject -Class Win32_useraccount -Filter 'Name = "mammotech"' | Set-WmiInstance -Arguments @{passwordexpires=$false} -Verbose


$mammo = Get-WmiObject -Class Win32_useraccount -Filter 'Name = "mammotech"' | Select-Object name, passwordchangeable, passwordexpires





Invoke-Command -ComputerName rad7-mta-02 -ScriptBlock {Get-WmiObject -Class Win32_useraccount -Filter 'Name = "mammotech"' | Set-WmiInstance -Arguments @{passwordchangeable = $false}; Get-WmiObject -Class Win32_useraccount -Filter 'Name = "mammotech"' | Set-WmiInstance -Arguments @{passwordexpires = $false}}
Invoke-Command -ComputerName rad7-crmc-02 -ScriptBlock {Get-WmiObject -Class Win32_useraccount -Filter 'Name = "mammotech"' | Select-Object name, passwordchangeable, passwordexpires}
