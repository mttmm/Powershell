#Creates new shortcut on user desktop
$WshShell = New-Object -comObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut("$Home\Desktop\Kiosk.lnk")
$Shortcut.TargetPath = "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe"
$Shortcut.Arguments = "-kiosk https://sid-500.com"
$Shortcut.Save()