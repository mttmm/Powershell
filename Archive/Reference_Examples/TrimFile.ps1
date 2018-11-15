$file = "C:\temp\tryingtofinddisabledmachines.txt"
$lines = (gc $file) | foreach {$_.Trim()}


$file = "c:\temp\adcomp.txt"
$lines = (gc $file) | foreach {$_.Trim()} | sc $file