#! /bin/bash
# this file in /usr/lib/nagios/

if ! [ -f /var/log/scripts/melony_status_nagios.log ]; then
   status=1
   #echo $status
      else

status=$(awk -F ";" '{print $1}' /var/log/scripts/melony_status_nagios.log)

cat /var/log/scripts/melony_status_nagios.log
#echo $status
exit $status
fi
