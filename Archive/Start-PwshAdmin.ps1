$AdminCred = Get-Credential -UserName "columbusrad\mm.adm" `
                            -Message "Enter your password for the DomainAdmin account:" 
Start-Process PowerShell.exe -Credential $AdminCred `
                             -ArgumentList "Start-Process PowerShell.exe -Verb RunAs" `
                             -NoNewWindow