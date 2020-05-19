#This script will pull down everything from an S3 bucket and using Robocopy will find files made in the last 24 hours,
#make a zip with those files and reupload it to S3
echo Creating_temp_directory
#Make temp directory to sync with S3
mkdir c:\INSERT_TEMP_DIRECTORY_HERE
echo Fetching_yesterdays_date
$yesterday = [DateTime]::Today.AddDays(-1).ToString("yyyyMMdd")
#Existing directory synced with S3
cd c:\INSERT_EXISTING_DIRECTORY_HERE
echo Getting_bucket_info...
#Make sure existing directory is up to date with latest S3 files
aws s3 sync s3://INSERT_BUCKETNAME_HERE . --profile default
#Optional - remove files that you want to exclude from the search 
echo Removing_large_backup_file_from_search
rm c:\INSERT_EXISTING_DIRECTORY_HERE\FILE_TO_EXCLUDE
echo Performing_copy...
robocopy C:\INSERT_EXISTING_DIRECTORY_HERE C:\INSERT_TEMP_DIRECTORY_HERE /MAXAGE:${yesterday} /E /XO
echo Making_zip...
compress-archive -path “c:\INSERT_TEMP_DIRECTORY_HERE” -destinationpath “c:\INSERT_TEMP_DIRECTORY_HERE\INSERT_ZIP_NAME_HERE.zip” -update -compressionlevel optimal
echo Uploading_zip...
aws s3 cp c:\INSERT_TEMP_DIRECTORY_HERE\INSERT_ZIP_NAME_HERE.zip s3://INSERT_BUCKETNAME_HERE/ --profile default
echo Cleaning_up_INSERT_TEMP_DIRECTORY_HERE_directory...
rm c:\INSERT_TEMP_DIRECTORY_HERE\ -recurse
echo Script_complete
