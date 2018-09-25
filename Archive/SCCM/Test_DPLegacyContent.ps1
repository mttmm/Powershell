Function Test-DPLegacyContent{
    Param($DPFolderPath)
 
    #Calculate child folders
    $pkgdir = join-path -path $DPFolderPath -ChildPath 'pkglib'
    $datadir = join-path -path $DPFolderPath -childpath 'datalib'
    $childdatafolders = Get-ChildItem -Directory $datadir
 
    ForEach($file in (get-childitem -file $pkgdir)){
        $filecontent = Get-content $file.FullName
        $expectedcontent = $filecontent.split('`n')[1].replace('=','')
        if($expectedcontent -match $file.basename){
            #legacy package
            $packageID = $file.basename
            #Check for missing INI files
            if(!(test-path (join-path $datadir -ChildPath "${expectedcontent}.ini"))){
                [pscustomobject]@{'PackageID'=$PackageID; 'Error'="Ini file missing in datalib for $packageID"}
            }
 
            #Check for mismatch in folder count
            [array]$matchingFolders = [array]($childdatafolders | Where{$_.Name -match $packageID})
            $foldercount = $matchingfolders.count
            if($foldercount -ne 1){
                [pscustomobject]@{'PackageID'=$PackageID; 'Error'="$foldercount folders found"}
            }
        }
     
        #Check for multiple content versions in pkg ini
        if(($filecontent.split('`n')[2].replace('=','')) -match $file.basename){
            [pscustomobject]@{'PackageID'=$PackageID; 'Error'="Multiple package versions found in pkglib ini"}
        }
    }
}
 