#!/bin/bash
# redirect stdout/stderr to a file
exec >/var/log/syslog 2>&1

status_code=$(curl --head --write-out %{http_code}  https://google.co.uk)

if [[ "$status_code" -ne 200 ]] ; then
  echo "Site is offline... rebooting"
  reboot
else
  echo "Site is online and healthy: https://google.co.uk"
fi