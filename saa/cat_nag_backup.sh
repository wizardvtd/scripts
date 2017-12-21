#!/bin/bash

cd /cygdrive/m/sync_log/
testfile=`find nag_backup_status.log -ctime +1`
	if [ ! -z testfile ] ;then
status=$(awk -F ";" '{print $1}' /cygdrive/m/sync_log/nag_backup_status.log)
cat /cygdrive/m/sync_log/nag_backup_status.log
exit $status
	else
echo "1; Logfile is old"
status="1"
exit $status
	fi


#echo $status
