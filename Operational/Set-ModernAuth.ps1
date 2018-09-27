Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Office\15.0\Common\Identity" EnableADAL -Type DWORD -Value 1 -Force -ErrorAction SilentlyContinue
Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Office\15.0\Common\Identity" Version -Type DWORD -Value 1 -Force -ErrorAction SilentlyContinue

get-ItemProperty "HKCU:\SOFTWARE\Microsoft\Office\16.0\Common\Identity"