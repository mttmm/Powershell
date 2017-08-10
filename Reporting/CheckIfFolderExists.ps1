
Get-Content C:\temp\no_OU.txt | `
   Select-Object @{Name='ComputerName';Expression={$_}},@{Name='FolderExist';Expression={ Test-Path "\\$_\c$\Windows\ccmcache"}}