#!/bin/bash

# Params check
#В переменной $@ параметры разбиты на отдельные «слова». Эти параметры можно перебирать в циклах. 

if [ -n "$1" ]; then
#   echo "Param is $1"


cd /cygdrive/m/sync_log/
#testfile=`find nag_backup_status.log -ctime +1`
testfile=`find "$1"_bstatus.stat -ctime +1`
	if [ ! -z testfile ] ;then
status=$(awk -F ";"  '{print $1}' /cygdrive/m/sync_log/"$1"_bstatus.stat)
cat /cygdrive/m/sync_log/"$1"_bstatus.stat
#echo $status
exit $status
	else
echo "1; Logfile is old"
status="1"
#echo $status

exit $status
	fi

	else
		echo "No parameters found. "
	fi


#echo $status
