#!/bin/bash

# URL to send the request to
URL="http://localhost:1234"

#Log file to append (will create if it doesn't exist')
FILE="/PATH/TO/LOGFILE"

SERVICE_NAME="SERVICE NAME"

# Send the request and store the response
RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" $URL)

# Check the HTTP status code
if [ $RESPONSE -eq 200 ]; then
    echo "Request was successful and $SERVICE_NAME is still online. HTTP status code: $RESPONSE" >> $FILE
else
    echo "Request failed to $SERVICE_NAME. HTTP status code: $RESPONSE" >> $FILE
    echo "Rebooting $SERVICE_NAME..." >> $FILE

    #INSERT REBOOT SERVICE CODE BELOW

fi
