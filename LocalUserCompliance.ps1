$mammo = Get-WmiObject -Class Win32_useraccount -Filter "LocalAccount=True" | Where-Object {$_.Name -like "mammotech"} | Select-Object name, passwordchangeable, passwordexpires
 if(!$mammo){$compliance = "No User Exists"}
    elseif (($mammo.passwordchangeable -eq $False) -and ($mammo.passwordexpires -eq $False)){
            $compliance = "Compliant"
        }else {
                $compliance= "Noncompliant"}
                Return $compliance
