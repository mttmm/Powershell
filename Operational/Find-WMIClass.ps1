function Find-WmiClass
{
    param([Parameter(Mandatory=$True,HelpMessage="Enter a keyword to search WMI")]$Keyword)

    Write-Progress -Activity "Finding WMI Classes" -Status "Searching"

    # find all WMI classes...
    Get-WmiObject -Class * -List |
    # that contain the search keyword
    Where-Object {
        # is there a property or method with the keyword?
        $containsMember = ((@($_.Properties.Name) -like "*$Keyword*").Count -gt 0) -or ((@($_.Methods.Name) -like "*$Keyword*").Count -gt 0)
        # is the keyword in the class name, and is it an interesting type of class?
        $containsClassName = $_.Name -like "*$Keyword*" -and $_.Properties.Count -gt 2 -and $_.Name -notlike 'Win32_Perf*'
        $containsMember -or $containsClassName
    }
    Write-Progress -Activity "Find WMI Classes" -Completed
}

$classes = Find-WmiClass

$classes |
    # let the user select one of the found classes
    Out-GridView -Title "Select WMI Class" -OutputMode Single |
    ForEach-Object {
        # get all instances of the selected class
        Get-CimInstance -Class $_.Name |
            # show all properties
            Select-Object -Property * |
            Out-GridView -Title "Instances"
    }