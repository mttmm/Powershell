$csv = gc "C:\temp\noclient1.txt"

Foreach($comp in $csv){
$counter++
#Write-Progress -Activity "Checking Connectivity" -CurrentOperation $comp -PercentComplete (($counter / $csv.count) * 100)

$connection = Test-Connection -ComputerName $comp -Count 1 -ErrorAction SilentlyContinue
if($connection ){
$comp | add-content c:\temp\active\success.txt

}
 Else{
$comp | add-content c:\temp\active\failure.txt
 
 }   
}