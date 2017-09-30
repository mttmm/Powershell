$Job = Start-BitsTransfer -Source http://WebServer/HugeFile.zip  -Destination C:\Folder -Asynchronous

  

  while (($Job.JobState -eq "Transferring") -or ($Job.JobState -eq  "Connecting")) `

  { sleep 5;} # Poll for status,  sleep for 5 seconds, or perform an action.

  

  Switch($Job.JobState)

  {

  "Transferred"  {Complete-BitsTransfer -BitsJob $Job}

  "Error" {$Job | Format-List  } # List the errors.

  default {"Other action"}  #  Perform corrective action.

  }