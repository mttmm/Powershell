Connect-VIServer vc01.chi03.radpartners.com


$stat = "disk.maxTotalLatency.latest", "disk.read.average"

# Update the Start and Finish values
$finish = Get-Date
$start = $finish.AddHours(-1)

$entities = Get-Inventory -Name "TRPZPSQLND01"

Get-Stat -Entity $entities -Stat $stat  -Start 2/22/2019 -Finish 2/25/2019 | Export-Csv C:\Temp\stats1.csv





$stat = "virtualDisk.totalReadLatency.average", "virtualDisk.totalWriteLatency.average"

#

$entities = Get-Inventory -Name "TRPZPSQLND01"

Get-Stat -Entity $entities -Stat $stat  -Start 2/22/2019 -Finish 2/25/2019 | Export-Csv C:\Temp\virtualdisklatency.csv



$stat = "storagePath.maxTotalLatency.latest", "storagePath.totalReadLatency.average", "storagePath.totalWriteLatency.average"


$entities = Get-Inventory -Name "TRPZPSQLND01"

Get-Stat -Entity $entities -Stat $stat -Start 2/22/2019 -Finish 2/25/2019 | Export-Csv C:\Temp\storagepathlatency.csv




$stat = "storageAdapter.maxTotalLatency.latest", "storageAdapter.queued.average", "storageAdapter.queueDepth.average", "storageAdapter.queueLatency.average", "storageAdapter.totalReadLatency.average", "storageAdapter.totalWriteLatency.average"

# Update the Start and Finish values


$entities = Get-Inventory -Name "TRPZPSQLND01"

Get-Stat -Entity $entities -Stat $stat -Start 2/22/2019 -Finish 2/25/2019 | Export-Csv C:\Temp\storageadapterlatency.csv




$stat = "datastore.datastoreNormalReadLatency.latest", "datastore.datastoreNormalWriteLatency.latest", "datastore.datastoreReadOIO.latest", "datastore.maxTotalLatency.latest"

# Update the Start and Finish values


$entities = Get-Inventory -Name "TRPZPSQLND01"

Get-Stat -Entity $entities -Stat $stat -Start 2/22/2019 -Finish 2/25/2019 | Export-Csv C:\Temp\datastorelatency.csv