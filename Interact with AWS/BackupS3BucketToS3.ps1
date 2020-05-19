#This script syncs a directory with an S3 bucket, makes a zip file of its contents and pushses that zip file to the same S3 bucket
#Directory to sync
mkdir c:\INSERT_SYNC_DIRECTORY_HERE
cd c:\INSERT_SYNC_DIRECTORY_HERE
#Perform S3 sync
aws s3 sync s3://INSERT_BUCKETNAME_HERE . --profile default
#Remove existing zip backup file
rm INSERT_ZIP_FILENAME_HERE.zip
#Create zip backup file
compress-archive -path “c:\INSERT_SYNC_DIRECTORY_HERE” -destinationpath “c:\INSERT_SYNC_DIRECTORY_HERE\INSERT_ZIP_FILENAME_HERE.zip” -update -compressionlevel optimal
#Upload zip file to S3 bucket
aws s3 cp .\INSERT_ZIP_FILENAME_HERE.zip s3://INSERT_BUCKETNAME_HERE --profile default
#Optional - Clean up sync directory 
rm c:\INSERT_SYNC_DIRECTORY_HERE\ -recurse