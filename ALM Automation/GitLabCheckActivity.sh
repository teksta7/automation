#!/bin/bash
echo '"################################################################################"'
echo '"################Setup and Checking for inactive GitLab accounts...##############"'
echo '"################################################################################"'
#Pull down list of users
userList=$(curl --header "PRIVATE-TOKEN: $1" -X GET "INSERT_GITLAB_URI_HERE/api/v4/users")
nonActiveList=''
checkTime=$(date +'%Y-%m-%d' -d "-14 Days")
activeMarker=true
echo '"################################################################################"'
echo '"################Parsing JSON and creating inactive user list...#################"'
echo '"################################################################################"'
echo '#Gitlab User List'
for row in $(echo "${userList}" | jq -r '.[] | @base64'); do
    _jq()
    {
     echo ${row} | base64 --decode | jq -r ${1}
    }
   url='INSERT_GITLAB_URI_HERE/api/v4/user?'$(_jq '.id')
   echo "#Checking user... "$(_jq '.id','.username','.name','.state')
   #Basic activity check
   if [ $(_jq '.state') != 'active' ]
   then
           echo "WARNING - Non active user found, adding entry into nonActiveList..."
           activeMarker=false
   fi

   #Datestamp check within last 14 days
   userActivityDate=$(curl --header "PRIVATE-TOKEN: $1" -X GET "${url}" | jq -r '.["last_activity_on"]')
   if [ $(date -d "${userActivityDate} -14 Days" +%s) -gt $(date -d "${checkTime} -14 Days" +%s) ] || [ $(date -d "${userActivityDate} -14 Days" +%s) -eq $(date -d "${checkTime} -14 Days" +%s) ]
   then
        echo "This user will need to be removed as their activity is too low."
        echo "Last login @ $(date -d "${userActivityDate} -14 Days" +'%Y-%m-%d') against min login date of ${checkTime}"
           activeMarker=false
   fi

   if [ activeMarker != true ]
   then
           nonActiveList="$nonActiveList $(_jq '.id'),$(_jq '.username'),$(_jq '.name'),$(_jq '.state')\n"
           echo "user tracked in list"
   fi
done

echo '"################################################################################"'
echo '"##################GitLab instance Non-Active User List...#######################"'
echo '"################################################################################"'
echo -e $nonActiveList
echo '"################################################################################"'
echo '"########################Remove inactive users...################################"'
echo '"################################################################################"'
#ALT Solution
#Requires admin rights to run the below command
#https://INSERT_GITLAB_URI_HERE/api/v4/user/activities
#More info @ https://docs.gitlab.com/ee/api/users.html#get-user-activities-admin-only

#Further check for accounts not marked as inactive but due to lack of recent sign in can be marked as inactive

#For each account id, if account passes certain threshold of older than 14 days with no sign in

#delete account id

for row in $(echo "${userList}" | jq -r '.[] |@base64'); do
    _jq()
    {
        echo ${row} | base64 --decode |jq -r ${1}
    }
    url='https://INSERT_GITLAB_URI_HERE/api/v4/user?'$(_jq '.id')
    if [[ $nonActiveList == *$(_jq '.username')* ]];
    then
           echo "User is mentioned for deletion"
           echo "#Deleting user ID... "$(_jq '.id','.username','.name')
           #ONLY UNCOMMENT WHEN READY TO PERFORMING TESTING ON A DUMMY USER ACCOUNT
           #curl --header "PRIVATE-TOKEN: $1" -X DELETE "${url}"
       else
           echo "This user doesn't need to be deleted, skipping"
       fi
done

echo '"###########################################################"'
echo '"###########################################################"'
echo '"Finished cleaning accounts from GitLab"'
