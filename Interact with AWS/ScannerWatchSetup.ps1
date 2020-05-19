#This script will watch a folder for new files and then push them to a different folder
#was created to support a scanner that couldn't directly push to a cloud based location so scans were sent to an old Windows PC that had this script
$watcher = New-Object System.IO.FileSystemWatcher
$watcher.IncludeSubdirectories = $true

#Insert the path you want to the script to watch
$watcher.Path = 'INSERT PATH HERE'
$watcher.EnableRaisingEvents = $true

$action =
{
    $path = $event.SourceEventArgs.FullPath
    $changetype = $event.SourceEventArgs.ChangeType
    Write-Host "UPLOAD STARTED: $path was $changetype at $(get-date)"
    #Mount the location that the PC has access to as a drive (user based access)
	net use Z: \\INSERT_IP_OR_DNS_NAME\INSERT_FOLDER_NAME IntegerScan20!! /user:INSERT_SERVER_NAME\INSERT_SERVER_USERNAME
	Write-Host "SERVER MOUNTED"
    #Copy itme to destination
    Copy-Item $path -Destination "INSERT_DESTINATION_HERE"
	Write-Host "FILE COPIED"
    #Unmount location
    net use Z: /delete
	Write-Host "UPLOAD COMPLETE"
}

Register-ObjectEvent $watcher 'Created' -Action $action