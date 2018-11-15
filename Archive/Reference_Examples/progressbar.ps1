$totalTimes = 10

  $i = 0

  for ($i=0;$i -lt $totalTimes; $i++) {

  $percentComplete = ($i / $totalTimes) * 100

  Write-Progress -Activity 'Doing thing' -Status "Did thing $i  times" -PercentComplete $percentComplete

  sleep 1

}